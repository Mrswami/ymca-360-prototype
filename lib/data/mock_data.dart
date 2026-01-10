import '../models/member.dart';
import '../models/trainer.dart';
import '../models/fitness_class.dart';

class MockData {
  static final List<Member> members = [
    Member(
      id: 'm1',
      firstName: 'James',
      lastName: 'Moreno',
      email: 'j.moreno@example.com',
      phone: '(555) 123-4567',
      membershipType: 'Family Plus',
      profileImage: 'https://randomuser.me/api/portraits/men/1.jpg',
      joinDate: DateTime(2023, 1, 15),
      barcode: 'YMCA-8829304',
    ),
    Member(
      id: 'm2',
      firstName: 'Linda',
      lastName: 'Kowalski',
      email: 'linda.k@example.com',
      phone: '(555) 987-6543',
      membershipType: 'Senior Individual',
      profileImage: 'https://randomuser.me/api/portraits/women/2.jpg',
      joinDate: DateTime(2020, 5, 20),
      barcode: 'YMCA-1122334',
    ),
    Member(
      id: 'm3',
      firstName: 'Marcus',
      lastName: 'Johnson',
      email: 'mjfitness@example.com',
      phone: '(555) 555-0199',
      membershipType: 'Young Adult',
      profileImage: 'https://randomuser.me/api/portraits/men/3.jpg',
      joinDate: DateTime(2024, 2, 10),
      barcode: 'YMCA-9988776',
    ),
    // ... we can generate more programmatically if needed
  ];

  static List<Member> get generatedMembers {
    // Generate 12 more procedural members
    List<Member> procedural = [];
    final names = [
      ('Alice', 'Smith', 'women/4.jpg'), ('Bob', 'Jones', 'men/5.jpg'), ('Charlie', 'Day', 'men/6.jpg'),
      ('Diana', 'Prince', 'women/7.jpg'), ('Ethan', 'Hunt', 'men/8.jpg'), ('Fiona', 'Gallagher', 'women/9.jpg'),
      ('George', 'Clooney', 'men/10.jpg'), ('Hannah', 'Montana', 'women/11.jpg'), ('Ian', 'McKellen', 'men/12.jpg'),
      ('Julia', 'Roberts', 'women/13.jpg'), ('Kevin', 'Bacon', 'men/14.jpg'), ('Laura', 'Croft', 'women/15.jpg')
    ];
    
    for (var i = 0; i < names.length; i++) {
      procedural.add(Member(
        id: 'gen_$i',
        firstName: names[i].$1,
        lastName: names[i].$2,
        email: '${names[i].$1.toLowerCase()}.${names[i].$2.toLowerCase()}@example.com',
        phone: '(555) 555-00${10 + i}',
        membershipType: i % 3 == 0 ? 'Family' : (i % 2 == 0 ? 'Individual' : 'Senior'),
        profileImage: 'https://randomuser.me/api/portraits/${names[i].$3}',
        joinDate: DateTime.now().subtract(Duration(days: i * 30)),
        barcode: 'YMCA-GEN-$i',
      ));
    }
    return [...members, ...procedural];
  }

  static final List<Trainer> trainers = [
    Trainer(
      id: 't1',
      name: 'Sarah Connor',
      bio: 'Certified Personal Trainer specializing in HIIT and functional strength. "Come with me if you want to lift."',
      specialties: ['HIIT', 'Strength', 'Weight Loss'],
      imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg', 
      weeklySchedule: {
        1: [900, 1700], // Mon 9-5
        3: [900, 1700], // Wed 9-5
        5: [900, 1500], // Fri 9-3
      },
    ),
    Trainer(
      id: 't2',
      name: 'Marcus Fenix',
      bio: 'Professional Bodybuilder and corrective exercise specialist. Focuses on form and hypertrophy.',
      specialties: ['Bodybuilding', 'Powerlifting', 'Rehab'],
      imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      weeklySchedule: {
        2: [1200, 2000], // Tue 12-8pm
        4: [1200, 2000], // Thu 12-8pm
        6: [1000, 1600], // Sat 10-4
      },
    ),
     Trainer(
      id: 't3',
      name: 'Elena Fisher',
      bio: 'Yoga and Pilates instructor with 10 years experience. Promotes mindfulness and core stability.',
      specialties: ['Yoga', 'Pilates', 'Flexibility'],
      imageUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
      weeklySchedule: {
        1: [700, 1200], // Mon 7am-12
        2: [700, 1200], // Tue 7am-12
        3: [700, 1200], 
        4: [700, 1200],
        5: [700, 1200],
      },
    ),
  ];

  static final List<FitnessClass> classes = [
    FitnessClass(
      id: 'c1',
      title: 'Sunrise Yoga',
      instructorId: 't3',
      description: 'Start your day with mindfulness and mobility.',
      category: 'Mind & Body',
      startTime: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 7, minute: 0),
      durationMinutes: 60,
      capacity: 20,
      enrolledCount: 15,
      location: 'Studio B',
    ),
     FitnessClass(
      id: 'c2',
      title: 'Cyclone Spin',
      instructorId: 't1',
      description: 'High intensity cardio on the bike.',
      category: 'Cardio',
      startTime: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 17, minute: 30),
      durationMinutes: 45,
      capacity: 15,
      enrolledCount: 15, // FULL
      location: 'Cycle Room',
    ),
     FitnessClass(
      id: 'c3',
      title: 'Aqua Fit',
      instructorId: 't2',
      description: 'Low impact resistance training in the pool.',
      category: 'Aquatics',
      startTime: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10, minute: 0),
      durationMinutes: 50,
      capacity: 30,
      enrolledCount: 5,
      location: 'Indoor Pool',
    ),
  ];
}
