import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';
import 'schedule_detail_screen.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Schedules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategory(context, 'Pool'),
          const SizedBox(height: 12),
          _buildCategory(context, 'Group Fitness'),
          const SizedBox(height: 12),
          _buildCategory(context, 'Gymnasium'),
          const SizedBox(height: 12),
          _buildCategory(context, 'Family Fun', isFamilyFun: true),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, {bool isFamilyFun = false}) {
    return InkWell(
      onTap: () {
        if (isFamilyFun) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleDetailScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title Schedule coming soon!')));
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
