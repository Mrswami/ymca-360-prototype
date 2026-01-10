enum AppointmentStatus { confirmed, cancelled, completed }

class Appointment {
  final String id;
  final String trainerId;
  final String memberId;
  final DateTime startTime;
  final int durationMinutes; // 30, 60, 90
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.trainerId,
    required this.memberId,
    required this.startTime,
    required this.durationMinutes,
    this.status = AppointmentStatus.confirmed,
  });

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));
}

// Mock Database of existing appointments to test overlap logic
final List<Appointment> mockAppointments = [
  Appointment(
    id: 'appt1',
    trainerId: 't1',
    memberId: 'm1',
    startTime: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10, minute: 0, second: 0, millisecond: 0, microsecond: 0), // Tomorrow 10am
    durationMinutes: 60,
  ),
];
