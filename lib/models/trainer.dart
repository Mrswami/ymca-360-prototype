class Trainer {
  final String id;
  final String name;
  final String bio;
  final List<String> specialties;
  final String imageUrl;
  
  // Weekly availability template (e.g., Mon 9-5, Wed 1-8)
  // Key: Day of week (1=Mon, 7=Sun)
  // Value: List of working hours formatted as integers (900 = 9am)
  // NOT final so we can edit it in the "Instructor View" demo
  Map<int, List<int>> weeklySchedule; 

  Trainer({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialties,
    required this.imageUrl,
    required this.weeklySchedule,
  });
}

