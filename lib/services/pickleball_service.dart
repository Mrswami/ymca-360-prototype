import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dupr_player.dart';

// Riverpod Provider
final pickleballServiceProvider = Provider((ref) => PickleballService());

class PickleballService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  // Future: Replace this with real API call using token
  // Future<DuprPlayer> getPlayerProfile(String duprId) async { ... }

  // SOA: Get player profile from the Cloud Service (was mock local data)
  Future<DuprPlayer> getMockPlayerProfile() async {
    // 💡 SOA EXPLANATION: We are now asking the "Service" for the data.
    // The app no longer "presents" fake data; it "requests" real data.
    
    try {
      // Point to localhost for the Demo to show the IT team
      _functions.useFunctionsEmulator('localhost', 5001);
      
      final HttpsCallable callable = _functions.httpsCallable('getPickleballProfile');
      final results = await callable.call(<String, dynamic>{
        'playerId': 'DUPR-88219',
      });

      return DuprPlayer.fromJson(Map<String, dynamic>.from(results.data));
    } catch (e) {
      print('SOA Service Error: $e');
      // Fallback for demo if emulator isn't running
      return DuprPlayer(
        playerId: "ERROR",
        fullName: "Service Offline",
        ratings: {"doubles": 0.0, "singles": 0.0},
        matches: 0,
        lastUpdate: "N/A",
        profileImageUrl: ""
      );
    }
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
