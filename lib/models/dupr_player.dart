class DuprPlayer {
  final String id;
  final String fullName;
  final double doublesRating;
  final double singlesRating;
  final int totalMatches;
  final String lastUpdated;
  final String profileImageUrl;

  DuprPlayer({
    required this.id,
    required this.fullName,
    required this.doublesRating,
    required this.singlesRating,
    required this.totalMatches,
    required this.lastUpdated,
    required this.profileImageUrl,
  });

  factory DuprPlayer.fromJson(Map<String, dynamic> json) {
    return DuprPlayer(
      id: json['playerId'] ?? '',
      fullName: json['fullName'] ?? 'Unknown Player',
      doublesRating: (json['ratings']?['doubles'] ?? 0.0).toDouble(),
      singlesRating: (json['ratings']?['singles'] ?? 0.0).toDouble(),
      totalMatches: json['matches'] ?? 0,
      lastUpdated: json['lastUpdate'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? 'https://i.pravatar.cc/300', // Placeholder
    );
  }

  // Helper to get formatted rating (e.g., "4.25")
  String get formattedDoubles => doublesRating.toStringAsFixed(2);
  String get formattedSingles => singlesRating.toStringAsFixed(2);
}
