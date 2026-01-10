import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/trainer.dart';
import '../theme/ymca_theme.dart';

class TrainerScheduleEditor extends StatefulWidget {
  final String trainerId;
  const TrainerScheduleEditor({super.key, required this.trainerId});

  @override
  State<TrainerScheduleEditor> createState() => _TrainerScheduleEditorState();
}

class _TrainerScheduleEditorState extends State<TrainerScheduleEditor> {
  late Trainer _trainer;
  late Map<int, List<int>> _schedule;

  @override
  void initState() {
    super.initState();
    // In a real app we'd fetch this. For mock, we find reference.
    _trainer = MockData.trainers.firstWhere((t) => t.id == widget.trainerId);
    // Create a copy of the schedule to edit
    _schedule = Map.from(_trainer.weeklySchedule);
  }

  void _toggleHour(int weekday, int hour) {
    setState(() {
      final hours = _schedule[weekday] ?? [];
      // Simplified: We assume ranges are stored as simply [Start, End] for the MVP logic
      // But for this editor, let's just show "Working / Not Working" for the day
      // Or edit the ranges.
      
      // Let's implement a simple "Work this day?" toggle for the MVP demo.
      if (hours.isEmpty) {
        _schedule[weekday] = [900, 1700]; // Default 9-5
      } else {
        _schedule.remove(weekday);
      }
      
      // Update global mock data
      _trainer.weeklySchedule = _schedule;
    });
  }

  void _editHours(int weekday) async {
    final current = _schedule[weekday] ?? [900, 1700];
    TimeOfDay start = _intToTime(current[0]);
    TimeOfDay end = _intToTime(current[1]);

    final newStart = await showTimePicker(context: context, initialTime: start, helpText: 'Start Time');
    if (newStart == null) return;
    
    if (!mounted) return;
    final newEnd = await showTimePicker(context: context, initialTime: end, helpText: 'End Time');
    if (newEnd == null) return;

    setState(() {
      _schedule[weekday] = [_timeToInt(newStart), _timeToInt(newEnd)];
      _trainer.weeklySchedule = _schedule;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Availability')),
      body: ListView.builder(
        itemCount: 7,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final day = index + 1; // 1 = Mon
          final hours = _schedule[day];
          final isWorking = hours != null && hours.isNotEmpty;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isWorking ? Colors.white : Colors.grey.shade100,
            child: ListTile(
              leading: Switch(
                value: isWorking, 
                activeColor: AppColors.ymcaBlue,
                onChanged: (_) => _toggleHour(day, 0),
              ),
              title: Text(_weekdayName(day), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                isWorking 
                  ? '${_formatTime(hours![0])} - ${_formatTime(hours[1])}' 
                  : 'Off',
                style: TextStyle(color: isWorking ? Colors.black : Colors.grey),
              ),
              trailing: isWorking 
                ? IconButton(icon: const Icon(Icons.edit), onPressed: () => _editHours(day))
                : null,
            ),
          );
        },
      ),
    );
  }

  String _weekdayName(int d) => ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d-1];
  
  String _formatTime(int t) {
    int h = t ~/ 100;
    int m = t % 100;
    String ampm = h >= 12 ? 'PM' : 'AM';
    if(h>12) h-=12;
    return '$h:${m.toString().padLeft(2,'0')} $ampm';
  }

  TimeOfDay _intToTime(int t) => TimeOfDay(hour: t ~/ 100, minute: t % 100);
  int _timeToInt(TimeOfDay t) => t.hour * 100 + t.minute;
}
