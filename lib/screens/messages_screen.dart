import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background from Screenshot 2
      appBar: AppBar(
        title: const Text('Messages/Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildNotification(
            title: 'Weather Closure Sunday, January 25',
            date: 'Sat, Jan 24',
            preview: 'For everyone\'s safety during the Ice Storm Warning, all Greater Austin YMCA locations will remain...',
            isUnread: true,
          ),
          _buildNotification(
            title: 'Weather Closure Saturday, January 24',
            date: 'Fri, Jan 23',
            preview: 'For everyone\'s safety, all Greater Austin YMCA centers will be closed Saturday, January 24, due to f...',
            isUnread: true,
          ),
          _buildNotification(
            title: 'TownLake YMCA Fire Alarm Test Wednesday, 1/14',
            date: 'Mon, Jan 12',
            preview: 'We will conduct a scheduled fire alarm test Wednesday, January 14 from 1:30 - 2:30 pm at TownLake YM...',
            isUnread: true,
          ),
          // Section Header for previous month
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1E1E1E),
            child: const Text('December 2025', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotification({
    required String title,
    required String date,
    required String preview,
    bool isUnread = false,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2C2C2C))),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Text(preview, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
          if (isUnread) ...[
            const SizedBox(width: 12),
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF2B7ABF), // Blue dot for unread
                shape: BoxShape.circle,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
