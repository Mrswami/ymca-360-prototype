import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  final List<String> _firstNames = [
    'James', 'Sarah', 'Mike', 'Emily', 'David', 'Jessica', 'Robert', 'Jennifer',
    'William', 'Linda', 'John', 'Elizabeth', 'Michael', 'Barbara', 'Richard', 'Susan',
    'Joseph', 'Patricia', 'Thomas', 'Margaret'
  ];

  final List<String> _lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
    'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'
  ];

  Future<void> seedDatabase() async {
    debugPrint("Starting Database Seed...");
    final batch = _firestore.batch();

    // 1. Create 20 Transactions
    for (int i = 0; i < 20; i++) {
      final name = "${_firstNames[_random.nextInt(_firstNames.length)]} ${_lastNames[_random.nextInt(_lastNames.length)]}";
      final isSuccess = _random.nextDouble() > 0.1; // 90% success rate
      final amount = _random.nextBool() ? 10.00 : 25.00; // Day Pass or Monthly
      
      // Random time in last 24 hours
      final timestamp = DateTime.now().subtract(Duration(minutes: _random.nextInt(1440)));

      final docRef = _firestore.collection('transactions').doc();
      batch.set(docRef, {
        'amount': amount,
        'status': isSuccess ? 'succeeded' : 'failed',
        'timestamp': Timestamp.fromDate(timestamp),
        'type': amount == 10.0 ? 'Day Pass' : 'Class Drop-in',
        'userId': 'mock_user_$i',
        'userName': name,
        'isMock': true,
      });
    }

    // 2. Create 20 Users (for User Management)
    // Note: This won't create Auth accounts, just Firestore records for the Admin table
    for (int i = 0; i < 20; i++) {
      final firstName = _firstNames[i];
      final lastName = _lastNames[i];
      final docRef = _firestore.collection('users').doc('mock_user_$i');
      
      batch.set(docRef, {
        'displayName': '$firstName $lastName',
        'email': '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com',
        'role': 'member',
        'joinDate': Timestamp.fromDate(DateTime.now().subtract(Duration(days: _random.nextInt(365)))),
        'status': 'active',
        'isMock': true,
      });
    }

    await batch.commit();
    debugPrint("Database Seed Complete!");
  }
}
