
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoggedIn;
  final UserRole role;
  final String? userId;
  final bool hasPendingMFA;

  const AuthState({
    this.isLoggedIn = false,
    this.role = UserRole.member,
    this.userId,
    this.hasPendingMFA = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    UserRole? role,
    String? userId,
    bool? hasPendingMFA,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      hasPendingMFA: hasPendingMFA ?? this.hasPendingMFA,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void loginAsMember(String memberId) {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.member,
      userId: memberId,
    );
  }

  void loginAsTrainer(String trainerId) {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.trainer,
      userId: trainerId,
    );
  }

  void loginAsManager() {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.manager,
      userId: 'admin',
    );
  }

  void logout() {
    state = const AuthState(isLoggedIn: false);
  }

  void toggleMFA(bool value) {
    state = state.copyWith(hasPendingMFA: value);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
