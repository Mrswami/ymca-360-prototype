import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pickleball_service.dart';
import '../models/dupr_player.dart';

// Provider for the service
final pickleballServiceProvider = Provider((ref) => PickleballService());

// Provider for the player data (AsyncValue handles loading/error states)
final duprProfileProvider = FutureProvider<DuprPlayer>((ref) async {
  final service = ref.watch(pickleballServiceProvider);
  return service.getMockPlayerProfile(); // Fetch mock data
});

// Provider for events
final pickleballEventsProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(pickleballServiceProvider);
  return service.getUpcomingEvents();
});
