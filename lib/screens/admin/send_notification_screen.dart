import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../theme/ymca_theme.dart';

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
      appBar: AppBar(
        title: const Text('Send Push Notification'),
        backgroundColor: AppColors.ymcaBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_notificationTypes[_selectedType], color: AppColors.ymcaBlue),
                          const SizedBox(width: 8),
                          const Text('Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      Text(
                        _titleController.text.isEmpty ? 'Notification Title' : _titleController.text,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _bodyController.text.isEmpty ? 'Notification message will appear here...' : _bodyController.text,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notification Type
              const Text('Notification Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(_notificationTypes[_selectedType]),
                ),
                items: _notificationTypes.keys.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_notificationTypeLabels[type]!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),

              // Title
              const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Pool Closed Tomorrow',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.title),
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}), // Trigger preview update
              ),
              const SizedBox(height: 16),

              // Body
              const Text('Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: 'e.g., The pool will be closed for maintenance from 8am-12pm',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.message),
                ),
                maxLines: 4,
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}), // Trigger preview update
              ),
              const SizedBox(height: 16),

              // Target Audience
              const Text('Send To', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTarget,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.people),
                ),
                items: _targetLabels.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTarget = value!),
              ),
              const SizedBox(height: 32),

              // Send Button
              ElevatedButton.icon(
                onPressed: _isSending ? null : _sendNotification,
                icon: _isSending 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSending ? 'Sending...' : 'Send Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ymcaBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 16),

              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notifications are sent instantly to all users in the selected group.',
                          style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
