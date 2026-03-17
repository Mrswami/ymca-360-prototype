import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/ymca_theme.dart';

/// My Y screen — matches the official YMCA 360 "My Y" tab showing branch info,
/// hours, directions, and action buttons.
class MyYScreen extends StatefulWidget {
  const MyYScreen({super.key});

  @override
  State<MyYScreen> createState() => _MyYScreenState();
}

class _MyYScreenState extends State<MyYScreen> {
  bool _showHours = true;

  final _hours = const [
    ('Mon - Thu', '5:00am - 10:00pm'),
    ('Fri',       '5:00am - 9:00pm'),
    ('Sat',       '8:00am - 7:00pm'),
    ('Sun',       '8:00am - 6:00pm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YMCA 360™', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Greater Austin YMCA', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.chat_bubble_outline_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch name row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TownLake YMCA',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
                      const SizedBox(height: 8),
                      const Text('1100 West Cesar Chavez', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      const Text('Austin, TX, 78703', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('0.03 miles away', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                // Branch switcher
                IconButton(
                  onPressed: _showBranchSwitcher,
                  icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.textSecondary, size: 28),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Hours / Contact toggle + Directions
            Row(
              children: [
                Expanded(
                  child: _buildToggleBar(),
                ),
                const SizedBox(width: 12),
                _buildDirectionsButton(),
              ],
            ),

            const SizedBox(height: 20),

            // Hours or Contact content
            _showHours ? _buildHoursSection() : _buildContactSection(),

            const SizedBox(height: 28),

            // Action buttons row
            Row(
              children: [
                Expanded(child: _buildPurpleActionButton(
                  icon: Icons.calendar_month_rounded,
                  label: 'Schedules',
                  onTap: () {},
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildPurpleActionButton(
                  icon: Icons.assignment_rounded,
                  label: 'Register for Programs',
                  onTap: () {},
                )),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleButton('Hours', _showHours, () => setState(() => _showHours = true))),
          Expanded(child: _toggleButton('Contact', !_showHours, () => setState(() => _showHours = false))),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.cardDarkAlt : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : AppColors.textSecondary,
            )),
      ),
    );
  }

  Widget _buildDirectionsButton() {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=1100+West+Cesar+Chavez,+Austin+TX')),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardDarkAlt,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            Icon(Icons.location_on_rounded, color: Colors.white, size: 22),
            SizedBox(height: 4),
            Text('Directions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TownLake Hours of Operation',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...(_hours.map((h) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(width: 110, child: Text(h.$1, style: const TextStyle(color: AppColors.textPrimary))),
              Text(h.$2, style: const TextStyle(color: AppColors.textPrimary)),
            ],
          ),
        ))),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.phone_rounded, color: AppColors.ymcaPurple),
          title: const Text('(512) 322-9622'),
          subtitle: const Text('TownLake Main Line', style: TextStyle(color: AppColors.textSecondary)),
          onTap: () => launchUrl(Uri.parse('tel:5123229622')),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.email_rounded, color: AppColors.ymcaPurple),
          title: const Text('info@austinymca.org'),
          subtitle: const Text('General Inquiries', style: TextStyle(color: AppColors.textSecondary)),
          onTap: () => launchUrl(Uri.parse('mailto:info@austinymca.org')),
        ),
      ],
    );
  }

  Widget _buildPurpleActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.ymcaPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.85), size: 26),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _showBranchSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Your Y', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ),
          _branchTile('TownLake YMCA', '1100 W Cesar Chavez · 0.03 mi', true),
          _branchTile('Southwest YMCA', '6219 Manchaca Rd · 7.2 mi', false),
          _branchTile('North Austin YMCA', '1000 W Rundberg Ln · 10.1 mi', false),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _branchTile(String name, String detail, bool selected) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(detail, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: selected ? const Icon(Icons.check_circle_rounded, color: AppColors.ymcaPurple) : null,
      onTap: () => Navigator.pop(context),
    );
  }
}
