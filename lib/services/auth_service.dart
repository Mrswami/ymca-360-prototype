enum UserRole {
  member,
  trainer,
  manager,
}

class AuthService {
  // Mock singleton for demo
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserRole _currentRole = UserRole.member;
  String? _currentUserId;

  UserRole get currentRole => _currentRole;
  String? get currentUserId => _currentUserId;

  // For Demo: simplified login
  void loginAsMember(String memberId) {
    _currentRole = UserRole.member;
    _currentUserId = memberId;
  }

  void loginAsTrainer(String trainerId) {
    _currentRole = UserRole.trainer;
    _currentUserId = trainerId;
  }

  void loginAsManager() {
    _currentRole = UserRole.manager;
    _currentUserId = 'admin';
  }
}
