import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dupr_provider.dart';
import '../theme/ymca_theme.dart';

class PickleballScreen extends ConsumerWidget {
  const PickleballScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duprProfileAsync = ref.watch(duprProfileProvider);
    final eventsAsync = ref.watch(pickleballEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickleball Center'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientTop, AppColors.gradientBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DUPR Rating Card
            _buildDuprCard(context, duprProfileAsync),
            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              "QUICK ACTIONS",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.calendar_today,
                    label: "Book Court",
                    color: AppColors.ymcaGreen,
                    onTap: () => _launchPickleballDen(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.emoji_events,
                    label: "Tournaments",
                    color: AppColors.ymcaOrange,
                    onTap: () {}, // TODO: Navigate to tournament list
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Live Court Status
            const Text(
              "LIVE FACILITY STATUS",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            _buildLiveStatusCard(),
            const SizedBox(height: 24),

            // Upcoming Events List
            const Text(
              "UPCOMING OPEN PLAY & LEAGUES",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            _buildEventsList(eventsAsync),
            const SizedBox(height: 24),

            // Leaderboard Snippet
            const Text(
              "TOWNLAKE TOP 3 (DUPR)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            _buildLeaderboardSnippet(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDarkAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ymcaGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.ymcaGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline, color: AppColors.ymcaGreen, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Open Play Active", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text("3 of 6 Courts Available • Closes at 9 PM", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSnippet() {
    final players = [
      {"name": "Sarah Connor", "rating": "4.85"},
      {"name": "James Moreno", "rating": "4.12"},
      {"name": "Alex Vance", "rating": "3.90"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDarkAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: players.asMap().entries.map((entry) {
          int idx = entry.key;
          var p = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Text("#${idx + 1}", style: TextStyle(color: idx == 0 ? AppColors.ymcaOrange : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                title: Text(p["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.ymcaNavy, borderRadius: BorderRadius.circular(12)),
                  child: Text(p["rating"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              if (idx < players.length - 1)
                const Divider(color: Colors.white10, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDuprCard(BuildContext context, AsyncValue duprProfileAsync) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.ymcaNavy, const Color(0xFF003D6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: duprProfileAsync.when(
          data: (profile) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profile.profileImageUrl),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ID: ${profile.id}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "DUPR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRatingStat("Doubles", profile.formattedDoubles),
                  Container(width: 1, height: 40, color: Colors.white30),
                  _buildRatingStat("Singles", profile.formattedSingles),
                ],
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (err, stack) => const Center(
            child: Text("Failed to load DUPR data", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardDarkAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(AsyncValue eventsAsync) {
    return eventsAsync.when(
      data: (events) => Column(
        children: events.map<Widget>((event) => Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          color: AppColors.cardDarkAlt,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.ymcaOrange.withOpacity(0.1),
              child: const Icon(Icons.sports_tennis, color: AppColors.ymcaOrange),
            ),
            title: Text(event, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            subtitle: const Text("YMCA Main Complex", style: TextStyle(color: AppColors.textSecondary)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ),
        )).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Text("Failed to load events"),
    );
  }

  Future<void> _launchPickleballDen() async {
    final url = Uri.parse('https://app.pickleballden.com'); // Could be deep link in future
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
