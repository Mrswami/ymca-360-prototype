import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _mockFriends = [
    {'name': 'Sarah Connor', 'avatar': 'Sarah+Connor', 'status': 'Online', 'activity': 'At Downtown YMCA'},
    {'name': 'Kyle Reese', 'avatar': 'Kyle+Reese', 'status': 'Offline', 'activity': 'Last seen 2h ago'},
    {'name': 'Marcus Wright', 'avatar': 'Marcus+Wright', 'status': 'Online', 'activity': 'Playing Pickleball'},
  ];

  final List<Map<String, String>> _mockRequests = [
    {'name': 'John Kim', 'avatar': 'John+Kim', 'mutual': '2 mutual friends'},
    {'name': 'Elena Fisher', 'avatar': 'Elena+Fisher', 'mutual': 'Also likes Yoga'},
  ];

  final List<Map<String, String>> _mockSuggestions = [
    {'name': 'Coach Carter', 'avatar': 'Coach', 'reason': 'Teaches your 9AM Class'},
    {'name': 'Alice Vance', 'avatar': 'Alice', 'reason': 'Checked in at TownLake'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.ymcaBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.ymcaBlue,
          tabs: [
            const Tab(text: 'Friends'),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Requests'),
                  if (_mockRequests.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('${_mockRequests.length}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ]
                ],
              ),
            ),
            const Tab(text: 'Find Members'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(),
          _buildRequestsList(),
          _buildFindMembers(),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    if (_mockFriends.isEmpty) {
      return Center(child: Text("No friends yet. Find some!", style: TextStyle(color: Colors.grey.shade600)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _mockFriends.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final friend = _mockFriends[index];
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${friend['avatar']}&background=random'),
              ),
              if (friend['status'] == 'Online')
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(color: Colors.green, border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
          title: Text(friend['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(friend['activity']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          trailing: IconButton(icon: const Icon(Icons.chat_bubble_outline, color: AppColors.ymcaBlue), onPressed: () {}),
        );
      },
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockRequests.length,
      itemBuilder: (context, index) {
        final req = _mockRequests[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${req['avatar']}&background=random'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(req['mutual']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ymcaBlue, foregroundColor: Colors.white, padding: EdgeInsets.zero),
                              child: const Text('Confirm'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text('Delete'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFindMembers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search members...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              Text('Suggested for you', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _mockSuggestions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sug = _mockSuggestions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${sug['avatar']}&background=random'),
                ),
                title: Text(sug['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(sug['reason']!, style: const TextStyle(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('Add +'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
