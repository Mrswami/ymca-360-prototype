import 'package:flutter/material.dart';
import '../widgets/ymca_background.dart';
import '../theme/ymca_theme.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('On Demand'),
        backgroundColor: AppColors.ymcaBlue.withOpacity(0.9),
      ),
      body: YMCABackground(
        // Use a different generic gym image for variety
        specificImage: 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?q=80&w=1975&auto=format&fit=crop', 
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Recommended for You'),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _videoCard('Morning Yoga', '20 min • Beginner', 'https://images.unsplash.com/photo-1544367563-12123d8965cd?q=80&w=2070&auto=format&fit=crop'),
                  _videoCard('HIIT Blast', '30 min • Advanced', 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?q=80&w=1925&auto=format&fit=crop'),
                  _videoCard('Core Strength', '15 min • Intermediate', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=2070&auto=format&fit=crop'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Categories'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _categoryChip('Yoga'),
                _categoryChip('Cardio'),
                _categoryChip('Strength'),
                _categoryChip('Pilates'),
                _categoryChip('Seniors'),
                _categoryChip('Kids'),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('New Arrivals'),
             SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                   _videoCard('Zumba Party', '45 min • Fun', 'https://images.unsplash.com/photo-1524594152303-9fd13543fe6e?q=80&w=2070&auto=format&fit=crop'),
                   _videoCard('Meditation', '10 min • Calm', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=2031&auto=format&fit=crop'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextButton(onPressed: (){}, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _videoCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))],
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _categoryChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
