import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YMCA 360'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeaturedCard(),
          const SizedBox(height: 20),
          const Text('Your Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildActivitySummary(),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/600x300'), // Placeholder for now
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Welcome Back!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Ready for your session?', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Row(
      children: [
        Expanded(child: _statCard('Visits', '12')),
        const SizedBox(width: 10),
        Expanded(child: _statCard('Streak', '3 Days')),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFDC0032))),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
