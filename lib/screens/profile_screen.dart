import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            SizedBox(height: 16),
            Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Member since 2024', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
