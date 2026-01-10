import '../models/trainer.dart';
import '../models/appointment.dart';

class AvailabilityService {
  /// The core function: Returns a list of start times (DateTimes) where a session of [durationMinutes]
  /// can be booked for a specific [trainer] given existing [appointments].
  static List<DateTime> getAvailableSlots({
    required Trainer trainer,
    required List<Appointment> existingAppointments, // Appointments for this trainer
    required DateTime targetDate,
    required int durationMinutes,
  }) {
    List<DateTime> availableSlots = [];
    
    // 1. Get working hours for the target day of the week
    // Dart DateTime weekday: 1=Mon, 7=Sun
    List<int>? hours = trainer.weeklySchedule[targetDate.weekday];
    
    if (hours == null || hours.isEmpty) {
      return []; // Trainer not working this day
    }

    // Parse the simplified schedule [900, 1700] -> Start 9:00, End 17:00
    // Handling multiple blocks e.g. [900, 1200, 1300, 1700] is possible but let's assume one block for MVP.
    int startInt = hours[0];
    int endInt = hours[1];

    DateTime workStart = _timeIntToDateTime(targetDate, startInt);
    DateTime workEnd = _timeIntToDateTime(targetDate, endInt);

    // 2. Generate all potential slots (e.g. every 15 or 30 mins)
    // YMCA usually books on the hour or half-hour. Let's step by 30 mins.
    DateTime cursor = workStart;
    
    while (cursor.isBefore(workEnd)) {
      DateTime proposedEnd = cursor.add(Duration(minutes: durationMinutes));
      
      // Check hard boundary: Does the session fit within working hours?
      if (proposedEnd.isAfter(workEnd)) {
        break; 
      }

      // 3. Check for Conflicts
      if (!_hasOverlap(cursor, proposedEnd, existingAppointments)) {
        availableSlots.add(cursor);
      }

      // Move cursor forward by 30 mins (default booking interval)
      cursor = cursor.add(const Duration(minutes: 30));
    }

    return availableSlots;
  }

  static bool _hasOverlap(DateTime start, DateTime end, List<Appointment> appointments) {
    for (var appt in appointments) {
      // Overlap logic: (StartA < EndB) and (EndA > StartB)
      if (start.isBefore(appt.endTime) && end.isAfter(appt.startTime)) {
        return true;
      }
    }
    return false;
  }

  static DateTime _timeIntToDateTime(DateTime date, int timeInt) {
    int hour = timeInt ~/ 100; // Integer division
    int minute = timeInt % 100;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
