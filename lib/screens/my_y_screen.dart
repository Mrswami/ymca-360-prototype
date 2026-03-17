import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/ymca_theme.dart';
import 'schedules_screen.dart';

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
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchedulesScreen())),
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildPurpleActionButton(
                  icon: Icons.assignment_rounded,
                  label: 'Register for\nPrograms',
                  onTap: () => _launchUrl('https://www.austinymca.org/programs'),
                )),
              ],
            ),

            const SizedBox(height: 12),
            
            // Second row for Quick Links
            Row(
              children: [
                Expanded(child: _buildPurpleActionButton(
                  icon: Icons.open_in_new_rounded,
                  label: 'Quick Links',
                  onTap: () {},
                )),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()), // Empty space to keep grid alignment
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
      isScrollControlled: true,
      backgroundColor: Colors.black, // Dark background
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select a New Branch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            
            // Current Branch Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text('CURRENT BRANCH', style: TextStyle(color: Color(0xFFE5A845), fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            _buildDetailedBranchTile('TownLake YMCA', '1100 West Cesar Chavez\nAustin, TX, 78703\n512-542-9622', isCurrent: true),
            
            // Other Branches
            _buildDetailedBranchTile('Southwest YMCA', '6219 Oakclaire Dr.\nAustin, TX, 78735\n512-891-9622'),
            _buildDetailedBranchTile('Springs Family YMCA', '27216 Ranch Rd 12\nDripping Springs, TX, 78620\n512-894-3309'),
            _buildDetailedBranchTile('Hays Communities YMCA', '465 Buda Sportsplex Dr\nBuda, TX, 78610\n512-523-0099'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedBranchTile(String name, String detail, {bool isCurrent = false}) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.4)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }
}
