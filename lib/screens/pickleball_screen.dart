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
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.calendar_today,
                    label: "Book Court",
                    color: Colors.green,
                    onTap: () => _launchPickleballDen(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.emoji_events,
                    label: "Tournaments",
                    color: Colors.orange,
                    onTap: () {}, // TODO: Navigate to tournament list
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Upcoming Events List
            const Text(
              "Upcoming Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildEventsList(eventsAsync),
          ],
        ),
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
            colors: [Colors.blue.shade900, Colors.blue.shade700],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
             BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.sports_tennis, color: Colors.white),
            ),
            title: Text(event),
            subtitle: const Text("YMCA Main Complex"),
            trailing: const Icon(Icons.chevron_right),
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
