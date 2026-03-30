import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../theme/ymca_theme.dart';
import '../../services/notification_service.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  String _selectedType = 'general';
  String _selectedTarget = 'all_users';
  bool _isSending = false;

  final Map<String, IconData> _notificationTypes = {
    'general': Icons.notifications,
    'class_update': Icons.fitness_center,
    'facility_alert': Icons.warning,
    'event': Icons.event,
    'maintenance': Icons.build,
  };

  final Map<String, String> _notificationTypeLabels = {
    'general': 'General Announcement',
    'class_update': 'Class Update',
    'facility_alert': 'Facility Alert',
    'event': 'Special Event',
    'maintenance': 'Maintenance Notice',
  };

  final Map<String, String> _targetLabels = {
    'all_users': 'All Users',
    'members': 'Members Only',
    'trainers': 'Trainers Only',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('sendNotification');
      
      final result = await callable.call({
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'type': _selectedType,
        'topic': _selectedTarget,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Notification sent to ${_targetLabels[_selectedTarget]}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _titleController.clear();
        _bodyController.clear();
        setState(() {
          _selectedType = 'general';
          _selectedTarget = 'all_users';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to send: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Send Push Notification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 📱 System-Style Notification Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PREVIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary)),
                  TextButton.icon(
                    onPressed: () {
                       NotificationService.showBookingConfirmation(
                        _titleController.text.isEmpty ? 'Test Notification' : _titleController.text, 
                        DateTime.now()
                       );
                    },
                    icon: const Icon(Icons.flash_on, size: 14, color: AppColors.ymcaGreen),
                    label: const Text('Local Test', style: TextStyle(fontSize: 11, color: AppColors.ymcaGreen)),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.ymcaOrange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_notificationTypes[_selectedType], color: AppColors.ymcaOrange, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _titleController.text.isEmpty ? 'Notification Title' : _titleController.text,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const Text('now', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bodyController.text.isEmpty ? 'The message you type below will appear here in the system tray.' : _bodyController.text,
                            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Notification Type Toggle
              const Text('SYSTEM TYPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _notificationTypes.keys.map((type) {
                    final isSelected = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_notificationTypeLabels[type]!),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedType = type),
                        selectedColor: AppColors.ymcaOrange.withOpacity(0.2),
                        backgroundColor: AppColors.cardDark,
                        labelStyle: TextStyle(color: isSelected ? AppColors.ymcaOrange : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppColors.ymcaOrange : Colors.white12)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  hintText: 'e.g., Facility Alert',
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.edit_note, color: AppColors.ymcaOrange),
                ),
                maxLength: 50,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a title' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Message
              TextFormField(
                controller: _bodyController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Message Body',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  hintText: 'Keep it short and actionable...',
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.chat_bubble_outline, color: AppColors.ymcaOrange),
                ),
                maxLines: 3,
                maxLength: 160,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a message' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Target
              DropdownButtonFormField<String>(
                value: _selectedTarget,
                dropdownColor: AppColors.cardDark,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Primary Audience',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.groups_outlined, color: AppColors.ymcaGreen),
                ),
                items: _targetLabels.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
                onChanged: (value) => setState(() => _selectedTarget = value!),
              ),
              const SizedBox(height: 32),

              // Send Button
              ElevatedButton(
                onPressed: _isSending ? null : _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ymcaOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 8,
                  shadowColor: AppColors.ymcaOrange.withOpacity(0.4),
                ),
                child: _isSending 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('DEploy Notification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1)),
              ),

              const SizedBox(height: 24),

              // Security Check
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.ymcaGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ymcaGreen.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.ymcaGreen, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Enterprise Shield active. This notification will be logged for compliance.',
                        style: TextStyle(fontSize: 12, color: AppColors.ymcaGreen.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
