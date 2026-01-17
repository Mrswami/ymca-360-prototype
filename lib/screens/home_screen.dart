import 'package:flutter/material.dart';
import '../widgets/ymca_background.dart';
import '../theme/ymca_theme.dart';
import '../services/auth_service.dart';
import 'income_verification_screen.dart';
import 'childcare_web_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text('YMCA 360'),
        backgroundColor: AppColors.ymcaBlue.withOpacity(0.9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none), 
            onPressed: () {},
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: YMCABackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Padding for Floating Role Switcher
          children: [
            // 0. URGENT ALERT (Simulated from Daxko)
            if (AuthService().hasPendingMFA) _buildAlertBanner(context),
            if (AuthService().hasPendingMFA) const SizedBox(height: 16),

            // 1. Digital ID Card "Quick Access"
            _buildCheckInCard(context),
            const SizedBox(height: 20),

            // 2. Generic Gym Info (Common Sense Feature)
            _buildBranchInfo(context),
            const SizedBox(height: 20),

            // Programs & Services
            const Text('Programs & Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildServicesSection(context),
            const SizedBox(height: 20),

            // 3. Featured Promo (Existing but improved)
            const Text('Featured', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildFeaturedCard(),
            
            const SizedBox(height: 20),
            
            // 4. Activity Stats
            const Text('Your Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildActivitySummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IncomeVerificationScreen())),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Action Required', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                   Text('Verify Income for "MFA Discount"', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBarcodeDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.ymcaBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.ymcaBlue.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Image.network(
                'https://bwipjs-api.metafloor.com/?bcid=code128&text=123456789&scale=3&height=10&color=000000', 
                height: 32,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scan to Check-In', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Tap to view your barcode', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _showBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Member Scan', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('James Moreno', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('TownLake YMCA', style: TextStyle(color: AppColors.ymcaBlue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Image.network(
                  'https://bwipjs-api.metafloor.com/?bcid=code128&text=YMCA-JAMES-MORENO&scale=4&height=12&color=000000',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text('ID: 8829304', style: TextStyle(fontSize: 18, letterSpacing: 2)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchInfo(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLocationPicker(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.ymcaBlue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TownLake YMCA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('1100 W Cesar Chavez St, Austin', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Change', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Today\'s Hours: 5:00 AM - 10:00 PM', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    final locations = [
      'TownLake YMCA',
      'Northwest Family YMCA',
      'East Communities YMCA',
      'Southwest Family YMCA',
      'Hays Communities YMCA',
      'Springs Family YMCA',
      'North Austin YMCA',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Select Your Branch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final loc = locations[index];
                final isSelected = loc.contains('TownLake');
                return ListTile(
                  leading: Icon(Icons.place, color: isSelected ? AppColors.ymcaBlue : Colors.grey),
                  title: Text(loc, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.ymcaBlue) : null,
                  onTap: () => Navigator.pop(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?q=80&w=2069&auto=format&fit=crop'), // Yoga image
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0,4)),
        ]
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('New Year, New You!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Join our Jan 15th Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Row(
      children: [
        Expanded(child: _statCard(Icons.local_fire_department, 'Visits', '12')),
        const SizedBox(width: 10),
        Expanded(child: _statCard(Icons.calendar_today, 'Streak', '3 Days')),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.ymcaBlue, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildServiceCard(
            context,
            icon: Icons.child_care,
            title: 'Childcare',
            color: Colors.pink,
            onTap: () => _showChildcareRedirectDialog(context),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildServiceCard(
            context,
            icon: Icons.pool,
            title: 'Swim', // Shortened to fit
            color: Colors.blue,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, // Fixed height for consistency
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showChildcareRedirectDialog(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: 'childcare_reg_link_clicked');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave App?'),
        content: const Text('You are now being redirected to the YMCA\'s secure childcare registration portal, powered by ezchildtrack.\n\nYou will be able to return to this app when you are finished.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChildcareWebView()));
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
