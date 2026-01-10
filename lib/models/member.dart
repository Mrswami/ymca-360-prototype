class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String membershipType; // e.g. "Family Plus", "Individual", "Senior"
  final String profileImage;
  final DateTime joinDate;
  final String barcode; // For scanning into the gym

  String get fullName => '$firstName $lastName';

  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.membershipType,
    required this.profileImage,
    required this.joinDate,
    required this.barcode,
  });
}
