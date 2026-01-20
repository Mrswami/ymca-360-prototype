import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/trainer.dart';
import '../models/appointment.dart';
import '../services/availability_service.dart';
import '../services/notification_service.dart';
import '../data/mock_data.dart';
import '../theme/ymca_theme.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  // State
  Trainer? _selectedTrainer;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1)); // Default tomorrow
  int _selectedDuration = 60; // 30, 60, 90
  List<DateTime> _availableSlots = [];
  DateTime? _selectedSlot;
  final Set<String> _viewedDays = {}; // Track viewed notification bubbles

  // Data
  final List<Trainer> _trainers = MockData.trainers;

  bool _hasSlots(DateTime date) {
    if (_selectedTrainer == null) return false;
    // Rapid check for availability using the service
    return AvailabilityService.getAvailableSlots(
      trainer: _selectedTrainer!,
      existingAppointments: mockAppointments.where((a) => a.trainerId == _selectedTrainer!.id).toList(),
      targetDate: date,
      durationMinutes: _selectedDuration,
    ).isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _selectedTrainer = _trainers[0];
    _calculateSlots();
    // Initialize Notifications
    NotificationService.init();
  }

  void _calculateSlots() {
    if (_selectedTrainer == null) return;
    _selectedSlot = null;
    final trainerAppts = mockAppointments.where((a) => a.trainerId == _selectedTrainer!.id).toList();

    setState(() {
      _availableSlots = AvailabilityService.getAvailableSlots(
        trainer: _selectedTrainer!,
        existingAppointments: trainerAppts,
        targetDate: _selectedDate,
        durationMinutes: _selectedDuration,
      );
    });
  }

  Future<void> _onConfirmBooking() async {
    if (_selectedSlot == null || _selectedTrainer == null) return;

    // Show Payment Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm & Pay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${_selectedTrainer!.name}'), radius: 16),
                const SizedBox(width: 8),
                Text('Session with ${_selectedTrainer!.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${_selectedDate.month}/${_selectedDate.day} @ ${_formatTime12h(_selectedSlot!)}',
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: ${_selectedDuration}m'),
                Text('\$${_selectedDuration == 30 ? '40.00' : (_selectedDuration == 60 ? '70.00' : '95.00')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Payment Method', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: const [
                  Icon(Icons.credit_card, color: AppColors.ymcaBlue),
                  SizedBox(width: 12),
                  Expanded(child: Text('Visa •••• 1234 (on file)')),
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ymcaBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close Payment Dialog
              _processPaymentAndBook();
            },
            child: const Text('Pay & Book'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPaymentAndBook() async {
    // 1. Show Processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.ymcaBlue)),
    );

    // 2. Simulate Delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context); // Close Spinner

    // 3. Logic & Notifications
    setState(() {
       _selectedSlot = null;
       _calculateSlots();
    });

    await NotificationService.showBookingConfirmation(
      _selectedTrainer!.name, 
      _selectedSlot ?? DateTime.now(), // Fallback if cleared too fast
    );

    // 4. Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Column(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 8),
            Text('Payment Successful'),
          ],
        ),
        content: const Text(
          'Your session has been confirmed and receipt sent to email.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton.icon(
            onPressed: _addToGoogleCalendar,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Add to Google Calendar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _addToGoogleCalendar() async {
    if (_selectedSlot == null || _selectedTrainer == null) return;

    final start = _selectedSlot!.toUtc();
    final end = _selectedSlot!.add(Duration(minutes: _selectedDuration)).toUtc();
    
    final dateFormat = "${start.year}${_twoDigits(start.month)}${_twoDigits(start.day)}T${_twoDigits(start.hour)}${_twoDigits(start.minute)}00Z";
    final endFormat = "${end.year}${_twoDigits(end.month)}${_twoDigits(end.day)}T${_twoDigits(end.hour)}${_twoDigits(end.minute)}00Z";
    
    // Using encodeFull/encodeComponent ensures special characters like spaces don't break the URI
    final urlString = 'https://www.google.com/calendar/render?action=TEMPLATE'
        '&text=${Uri.encodeComponent("PT Session with ${_selectedTrainer!.name}")}'
        '&dates=$dateFormat/$endFormat'
        '&details=${Uri.encodeComponent("Personal Training session at YMCA 360.")}'
        '&location=YMCA';

    final Uri url = Uri.parse(urlString);
    
    try {
      // Force open in external browser/app (Chrome/Calendar)
      // handling Android 11+ query visibility constraints by just trying to launch
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Could not launch calendar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Calendar app')),
        );
      }
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  void _showTrainerDetails(Trainer trainer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Container(width: 40, height: 4, color: Colors.grey.shade300, margin: const EdgeInsets.only(bottom: 20))),
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Colors.grey.shade200, child: Text(trainer.name[0], style: const TextStyle(fontSize: 32))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trainer.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(trainer.specialties.join(" • "), style: const TextStyle(color: AppColors.ymcaBlue)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(trainer.bio, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
            const SizedBox(height: 24),
            const Text('Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Simple visual of their weekly schedule
            ...trainer.weeklySchedule.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 40, child: Text(_weekdayName(e.key), style: const TextStyle(fontWeight: FontWeight.bold))),
                    Text('${(e.value[0]/100).round()}:00 - ${(e.value[1]/100).round()}:00'),
                  ],
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Personal Training')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2070&auto=format&fit=crop', // Gym Background
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Column(
            children: [
              _buildTrainerSelector(),
              _buildDateSelector(),
              _buildDurationSelector(),
              const Divider(height: 1),
              Expanded(
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  child: _availableSlots.isEmpty 
                    ? _buildEmptyState()
                    : _buildSlotsGrid(),
                ),
              ),
              _buildBottomActionArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerSelector() {
    return Container(
      color: Colors.white,
      height: 140, // Increased height for Info button
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _trainers.length,
        itemBuilder: (context, index) {
          final trainer = _trainers[index];
          final isSelected = _selectedTrainer == trainer;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTrainer = trainer;
                      _calculateSlots();
                    });
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.ymcaBlue.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.ymcaBlue : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(trainer.name[0]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainer.name.split(' ')[0], 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 12,
                            color: isSelected ? AppColors.ymcaBlue : Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showTrainerDetails(trainer),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Info', style: TextStyle(fontSize: 11)),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    final dates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    
    return Container(
      height: 90, // Increased height for bubble space
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = isSameDay(_selectedDate, date);
          
          final hasSlots = _hasSlots(date);
          final dateKey = "${date.year}-${date.month}-${date.day}";
          final showNotification = hasSlots && !_viewedDays.contains(dateKey);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (hasSlots && !_viewedDays.contains(dateKey)) {
                  _viewedDays.add(dateKey);
                }
                _selectedDate = date;
                _calculateSlots();
              });
            },
            child: Container(
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.ymcaBlue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected 
                    ? AppColors.ymcaBlue 
                    : (showNotification ? Colors.green.withOpacity(0.5) : Colors.transparent),
                  width: showNotification ? 1.5 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdayName(date.weekday),
                          style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: isSelected ? Colors.white : (hasSlots ? Colors.black87 : Colors.grey)
                          ),
                        ),
                      ],
                    ),
                  ),
                   if (showNotification)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green, // Notification Bubble
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1))
                          ]
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [30, 60, 90].map((int duration) {
          final isSelected = _selectedDuration == duration;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text('${duration} min'),
              selected: isSelected,
              selectedColor: AppColors.ymcaBlue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedDuration = duration;
                    _calculateSlots();
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No ${_selectedDuration}min slots available.', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSlotsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _availableSlots.length,
      itemBuilder: (context, index) {
        final slot = _availableSlots[index];
        final isSelected = _selectedSlot == slot;

        return OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? AppColors.ymcaBlue : Colors.white,
            side: BorderSide(color: isSelected ? AppColors.ymcaBlue : Colors.grey.shade300, width: 1.5),
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            _formatTime12h(slot),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _selectedSlot == null ? null : _onConfirmBooking,
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
            child: const Text('Confirm Booking'),
          ),
        ),
      ),
    );
  }

  // Helpers
  String _formatTime12h(DateTime date) {
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    
    return '$hour:$minute $ampm';
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  String _weekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }
}
