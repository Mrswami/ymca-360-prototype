import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'admin/user_management_screen.dart';
import 'admin/transaction_review_screen.dart';
import 'admin/send_notification_screen.dart';
import '../theme/ymca_theme.dart';
import '../providers/auth_provider.dart';
import '../services/dev/data_seeder.dart';

class ManagerDashboard extends ConsumerStatefulWidget {
  const ManagerDashboard({super.key});

  @override
  ConsumerState<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends ConsumerState<ManagerDashboard> {
  bool _isSeeding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const Text('Admin Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.people_alt,
                title: 'User Management',
                subtitle: 'View and edit registered members (Firestore)',
                color: Colors.purple,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUsersScreen())),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.notifications_active,
                title: 'Send Push Notification',
                subtitle: 'Send announcements to all users',
                color: Colors.deepOrange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SendNotificationScreen())),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.verified_user, // Was Icons.security
                title: 'Income Verification',
                subtitle: 'Review uploaded documents',
                color: Colors.orange,
                onTap: () {
                   // Placeholder for document review screen
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification Queue: 0 Pending')));
                },
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.analytics,
                title: 'Analytics Dashboard',
                subtitle: 'View registration & usage stats (Firebase)',
                color: Colors.blue,
                onTap: () async {
                  final url = Uri.parse('https://console.firebase.google.com/u/0/project/_/analytics/reports/dashboard');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                     if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch Analytics')));
                     }
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.payments,
                title: 'Daily Batch',
                subtitle: 'Live feed of Stripe/POS transactions',
                color: Colors.green,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionReviewScreen())),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                context,
                icon: Icons.storage,
                title: 'Seed Database (Demo)',
                subtitle: 'Generate 20 mock users & transactions',
                color: Colors.teal,
                isLoading: _isSeeding,
                onTap: _isSeeding ? () {} : () async {
                  setState(() => _isSeeding = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seeding Database...')));
                  
                  await DataSeeder().seedDatabase();
                  
                  if (context.mounted) {
                    setState(() => _isSeeding = false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done! Refresh lists to see data.'), backgroundColor: Colors.green));
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildMFAToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.ymcaBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
          SizedBox(height: 16),
          Text('Manager Control Center', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Access Level: Unrestricted', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap, bool isLoading = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: isLoading 
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: color)) 
          : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMFAToggle() {
    final hasPendingMFA = ref.watch(authProvider).hasPendingMFA;
    
    return Card(
      child: SwitchListTile(
        title: const Text('Simulate MFA Trigger'),
        subtitle: const Text('Show "Action Required" on Member Home'),
        value: hasPendingMFA,
        activeColor: Colors.red,
        onChanged: (val) {
          ref.read(authProvider.notifier).toggleMFA(val);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('MFA Alert turned ${val ? "ON" : "OFF"}')));
        },
      ),
    );
  }
}
