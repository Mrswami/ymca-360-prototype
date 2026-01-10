import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/member.dart';
import '../theme/ymca_theme.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Management')),
      body: ListView.builder(
        itemCount: MockData.generatedMembers.length,
        itemBuilder: (context, index) {
          final member = MockData.generatedMembers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(member.profileImage),
              backgroundColor: Colors.grey.shade300,
            ),
            title: Text(member.fullName),
            subtitle: Text(member.membershipType),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showMemberDetails(context, member),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  void _showMemberDetails(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(member.profileImage)),
            const SizedBox(height: 16),
            Text(member.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(member.membershipType, style: const TextStyle(color: AppColors.ymcaBlue, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            _detailRow(Icons.email, member.email),
            const SizedBox(height: 12),
            _detailRow(Icons.phone, member.phone),
            const SizedBox(height: 12),
            _detailRow(Icons.qr_code, member.barcode),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
