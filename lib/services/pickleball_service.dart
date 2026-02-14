import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dupr_player.dart';

// Riverpod Provider
final pickleballServiceProvider = Provider((ref) => PickleballService());

class PickleballService {
  
  // Future: Replace this with real API call using token
  // Future<DuprPlayer> getPlayerProfile(String duprId) async { ... }

  // MOCK: Get player profile (Simulating API delay)
  Future<DuprPlayer> getMockPlayerProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network lag
    
    // Mock Response
    final mockJson = {
      "playerId": "DUPR-88219",
      "fullName": "Jacob Moreno",
      "ratings": {
        "doubles": 4.12,  // Hard to be a 4.0!
        "singles": 3.85
      },
      "matches": 42,
      "lastUpdate": "2026-02-13",
      "profileImageUrl": "https://randomuser.me/api/portraits/men/32.jpg"
    };

    return DuprPlayer.fromJson(mockJson);
  }

  // MOCK: Get upcoming tournament/league events
  Future<List<String>> getUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      "Spring Open League - Starts Mar 1st",
      "Advanced Doubles - Sat 10AM",
      "Beginner Clinic - Tue 6PM"
    ];
  }
}
