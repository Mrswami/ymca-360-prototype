
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoggedIn;
  final UserRole role;
  final String? userId;
  final bool hasPendingMFA;
  final bool isLoading;

  const AuthState({
    this.isLoggedIn = false,
    this.role = UserRole.member,
    this.userId,
    this.hasPendingMFA = false,
    this.isLoading = true, // Default to true to allow session check
  });

  AuthState copyWith({
    bool? isLoggedIn,
    UserRole? role,
    String? userId,
    bool? hasPendingMFA,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      userId: userId ?? this.userId,
      hasPendingMFA: hasPendingMFA ?? this.hasPendingMFA,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // We start loading, and trigger the check immediately
    // Note: StateNotifiers shouldn't be async in build, but we can fire-and-forget or use a FutureProvider.
    // For this pattern, we just set initial state and call checkSession.
    Future.microtask(() => checkSession());
    return const AuthState(isLoading: true);
  }

  Future<void> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedIn) {
        final roleString = prefs.getString('role') ?? 'member';
        final userId = prefs.getString('userId');
        
        UserRole role = UserRole.member;
        if (roleString == 'trainer') role = UserRole.trainer;
        if (roleString == 'manager') role = UserRole.manager;

        state = state.copyWith(
          isLoggedIn: true,
          role: role,
          userId: userId,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loginAsMember(String memberId, {bool rememberMe = false}) async {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.member,
      userId: memberId,
    );
    if (rememberMe) _persistSession(true, UserRole.member, memberId);
  }

  Future<void> loginAsTrainer(String trainerId, {bool rememberMe = false}) async {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.trainer,
      userId: trainerId,
    );
    if (rememberMe) _persistSession(true, UserRole.trainer, trainerId);
  }

  Future<void> loginAsManager({bool rememberMe = false}) async {
    state = state.copyWith(
      isLoggedIn: true,
      role: UserRole.manager,
      userId: 'admin',
    );
    if (rememberMe) _persistSession(true, UserRole.manager, 'admin');
  }

  Future<void> logout() async {
    state = const AuthState(isLoggedIn: false, isLoading: false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void toggleMFA(bool value) {
    state = state.copyWith(hasPendingMFA: value);
  }

  Future<void> _persistSession(bool isLoggedIn, UserRole role, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('role', role.name); // Using default enum toString/name
    await prefs.setString('userId', userId);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
