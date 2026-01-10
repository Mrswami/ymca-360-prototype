class FitnessClass {
  final String id;
  final String title;
  final String instructorId;
  final String description;
  final String category; // Yoga, HIIT, Aqua, etc.
  final DateTime startTime;
  final int durationMinutes;
  final int capacity;
  final int enrolledCount;
  final String location; // "Studio A", "Pool", "Cyclone Room"

  FitnessClass({
    required this.id,
    required this.title,
    required this.instructorId,
    required this.description,
    required this.category,
    required this.startTime,
    required this.durationMinutes,
    required this.capacity,
    required this.enrolledCount,
    required this.location,
  });
}
