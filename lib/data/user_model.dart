class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role; // 'member', 'trainer', 'manager'
  final String status; // 'Active', 'Inactive', 'Past Due'
  final DateTime joinedAt;
  final String? homeBranch;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.homeBranch,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'member',
      status: data['status'] ?? 'Active',
      joinedAt: DateTime.tryParse(data['joinedAt'] ?? '') ?? DateTime.now(),
      homeBranch: data['homeBranch'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'status': status,
      'joinedAt': joinedAt.toIso8601String(),
      'homeBranch': homeBranch,
    };
  }

  String get fullName => '$firstName $lastName';
}
