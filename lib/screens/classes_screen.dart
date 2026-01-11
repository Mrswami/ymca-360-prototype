import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';
import '../models/fitness_class.dart'; // We actually made this earlier!

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Group Fitness', 'Aquatics', 'Gymnasium', 'Family Play'];

  // Mock Schedule Data for TownLake
  final List<Map<String, dynamic>> _schedule = [
    {
      'time': '06:00 AM',
      'title': 'Masters Swim',
      'category': 'Aquatics',
      'location': 'Indoor Pool',
      'duration': '60 min',
      'instructor': 'Coach Dave'
    },
    {
      'time': '08:30 AM',
      'title': 'BodyPump',
      'category': 'Group Fitness',
      'location': 'Studio A',
      'duration': '60 min',
      'instructor': 'Sarah C.'
    },
    {
      'time': '09:00 AM',
      'title': 'Pickleball Open Play',
      'category': 'Gymnasium',
      'location': 'South Gym',
      'duration': '2 hrs',
      'instructor': 'Staff'
    },
    {
      'time': '09:30 AM',
      'title': 'Vinyasa Yoga',
      'category': 'Group Fitness',
      'location': 'Studio B',
      'duration': '60 min',
      'instructor': 'Elena F.'
    },
    {
      'time': '10:00 AM',
      'title': 'Aqua Aerobics',
      'category': 'Aquatics',
      'location': 'Indoor Pool',
      'duration': '45 min',
      'instructor': 'Martha'
    },
    {
      'time': '11:15 AM',
      'title': 'Silver Sneakers',
      'category': 'Group Fitness',
      'location': 'Studio A',
      'duration': '50 min',
      'instructor': 'Joy'
    },
    {
      'time': '04:00 PM',
      'title': 'Open Basketball',
      'category': 'Gymnasium',
      'location': 'Main Gym',
      'duration': '3 hrs',
      'instructor': 'Staff'
    },
    {
      'time': '05:30 PM',
      'title': 'Zumba',
      'category': 'Group Fitness',
      'location': 'Studio A',
      'duration': '50 min',
      'instructor': 'Maria'
    },
    {
      'time': '06:00 PM',
      'title': 'Family Swim',
      'category': 'Aquatics',
      'location': 'Indoor Pool',
      'duration': '90 min',
      'instructor': 'Lifeguard'
    },
    {
      'time': '06:00 PM',
      'title': 'Kids Zone',
      'category': 'Family Play',
      'location': 'Community Room',
      'duration': '60 min',
      'instructor': 'Staff'
    },
    {
      'time': '06:30 PM',
      'title': 'HIIT Circuit',
      'category': 'Group Fitness',
      'location': 'Wellness Floor',
      'duration': '45 min',
      'instructor': 'Marcus'
    },
    {
      'time': '07:00 PM',
      'title': 'Family Yoga',
      'category': 'Family Play',
      'location': 'Studio B',
      'duration': '45 min',
      'instructor': 'Elena F.'
    },
  ];

  List<Map<String, dynamic>> get _filteredSchedule {
    if (_selectedCategory == 'All') return _schedule;
    return _schedule.where((item) => item['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TownLake Schedule'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.ymcaBlue.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.ymcaBlue : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(color: isSelected ? AppColors.ymcaBlue : Colors.grey.shade300),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredSchedule.length,
        itemBuilder: (context, index) {
          final item = _filteredSchedule[index];
          return _buildClassCard(item);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Filter Date'),
        icon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> item) {
    Color stripColor;
    IconData icon;
    switch(item['category']) {
      case 'Aquatics': stripColor = Colors.blue; icon = Icons.pool; break;
      case 'Group Fitness': stripColor = Colors.orange; icon = Icons.fitness_center; break;
      case 'Gymnasium': stripColor = Colors.red; icon = Icons.sports_basketball; break;
      case 'Family Play': stripColor = Colors.green; icon = Icons.family_restroom; break;
      default: stripColor = Colors.grey; icon = Icons.event;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color Strip
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
            ),
            // Time Column
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade50,
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['time'].split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(item['time'].split(' ')[1], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(item['duration'], style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                ],
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['category'], style: TextStyle(color: stripColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(item['location'], style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        const Spacer(),
                        const Icon(Icons.person, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['instructor'], style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Action
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.ymcaBlue),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${item['title']} to your calendar!')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
