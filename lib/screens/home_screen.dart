import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/ymca_theme.dart';
import '../providers/auth_provider.dart';
import '../screens/barcode_screen.dart';
import '../screens/pickleball_screen.dart';
import '../screens/income_verification_screen.dart';
import '../services/stripe_service.dart';
import '../widgets/pickleball_hub_card.dart';
import 'department_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final hasPendingMFA = authState.hasPendingMFA;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(context, authState),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // Urgent alert
          if (hasPendingMFA) _buildAlertBanner(context),

          // Promo banner carousel
          _buildPromoBanner(),

          const SizedBox(height: 16),

          // Day Pass Card (Stripe Integration)
          _buildDayPassCard(context, ref),

          const SizedBox(height: 16),

          // Quick action 2x2 grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildQuickActionGrid(context, ref),
          ),

          const SizedBox(height: 24),

          // Popular classes section
          _buildSectionHeader('Popular'),
          _buildVideoThumbnailRow([
            ('Intro to Barre', 'assets/images/barre.jpg'),
            ('Yoga Flow 5', 'assets/images/yoga.jpg'),
          ]),

          const SizedBox(height: 24),

          // For You section
          _buildSectionHeader('For You'),
          _buildVideoThumbnailRow([
            ('Intro to Beginner\n4 Week Training', 'assets/images/training.jpg'),
            ('Beginner Flow 6', 'assets/images/beginner.jpg'),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context, AuthState authState) {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      titleSpacing: 16,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('YMCA 360™',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Greater Austin YMCA',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
      actions: [
        // Barcode / member ID icon
        IconButton(
          icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
          tooltip: 'Member ID',
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const BarcodeScreen())),
        ),
        IconButton(icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white), onPressed: () {}),
        IconButton(icon: const Icon(Icons.search_rounded, color: Colors.white), onPressed: () {}),
        IconButton(icon: const Icon(Icons.menu_rounded, color: Colors.white), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 6),
            child: Text(
              'Hi, Jacob',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Alert Banner ───────────────────────────────────────────────────────────
  Widget _buildAlertBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const IncomeVerificationScreen())),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade900.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange.shade700),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(child: Text('Action Required: Income verification pending',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
            Icon(Icons.chevron_right, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  // ── Promo Banner Carousel ──────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    final promos = [
      _PromoItem('COUNSELING', 'Life can be hard. We\'re here to help.', Colors.teal),
      _PromoItem('PICKLEBALL OPEN PLAY', 'Courts available daily 6am–9pm', AppColors.ymcaPurple),
      _PromoItem('KID FIT SUMMER CAMP', 'Register now — spots filling fast!', Colors.blue.shade800),
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: promos.length,
        itemBuilder: (ctx, i) {
          final p = promos[i];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: p.color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(p.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(p.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Day Pass Card (Stripe Checkout) ────────────────────────────────────────
  Widget _buildDayPassCard(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDarkAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guest Day Pass', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('\$10 for full facility access', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.ymcaPurple,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const Center(child: CircularProgressIndicator()),
              );
              final success = await StripeService.instance.makePayment(
                amount: 10.00,
                userId: authState.userId ?? 'anonymous',
                userName: 'Jacob M', // Mock name
              );
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Payment Successful!' : 'Payment Failed'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Quick Action 2x2 Grid ──────────────────────────────────────────────────
  Widget _buildQuickActionGrid(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _actionTile(
              context,
              icon: Icons.calendar_today_rounded,
              label: 'My Schedule',
              onTap: () {},
            )),
            const SizedBox(width: 10),
            Expanded(child: _actionTile(
              context,
              icon: Icons.emoji_events_rounded,
              label: 'My Challenges',
              onTap: () {},
            )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _actionTile(
              context,
              icon: Icons.sports_tennis_rounded,
              label: 'Pickleball Hub',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PickleballScreen())),
            )),
            const SizedBox(width: 10),
            Expanded(child: _actionTile(
              context,
              icon: Icons.people_alt_rounded,
              label: 'My Team',
              onTap: () {},
            )),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.ymcaPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.85), size: 24),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
    );
  }

  // ── Video Thumbnail Row ────────────────────────────────────────────────────
  Widget _buildVideoThumbnailRow(List<(String, String)> items) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: items.map((item) => _videoThumbnail(item.$1, item.$2)).toList(),
      ),
    );
  }

  Widget _videoThumbnail(String title, String imagePath) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Placeholder gradient image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.cardDarkAlt, AppColors.cardDark],
                ),
              ),
              child: const Center(
                child: Icon(Icons.fitness_center_rounded, color: Colors.white30, size: 48),
              ),
            ),
          ),
          // YMCA badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.ymcaPurple,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('Y', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
              ),
            ),
          ),
          // Title at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                ),
              ),
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoItem {
  final String title;
  final String subtitle;
  final Color color;
  _PromoItem(this.title, this.subtitle, this.color);
}
