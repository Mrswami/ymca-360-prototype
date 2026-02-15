import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

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
    Future.microtask(() => checkSession());
    return const AuthState(isLoading: true);
  }

  Future<void> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shouldRemember = prefs.getBool('isLoggedIn') ?? false;
      final savedRole = prefs.getString('role');

      // Check Real Firebase User
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (shouldRemember && firebaseUser != null && savedRole != null) {
        UserRole role = UserRole.values.firstWhere(
          (e) => e.name == savedRole, 
          orElse: () => UserRole.member
        );

        state = state.copyWith(
          isLoggedIn: true,
          role: role,
          userId: firebaseUser.uid,
          isLoading: false,
        );
      } else {
        // If we shouldn't remember, or no user exists, clear everything
        if (firebaseUser != null && !shouldRemember) {
          await FirebaseAuth.instance.signOut();
        }
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loginAsMember({bool rememberMe = false}) async {
    await _performLogin(UserRole.member, rememberMe);
  }

  Future<void> loginAsTrainer({bool rememberMe = false}) async {
    await _performLogin(UserRole.trainer, rememberMe);
  }

  Future<void> loginAsManager({bool rememberMe = false}) async {
    await _performLogin(UserRole.manager, rememberMe);
  }

  Future<void> _performLogin(UserRole role, bool rememberMe) async {
    try {
      state = state.copyWith(isLoading: true);
      
      // 1. Authenticate anonymously (or standard sign-in later)
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user!;
      final uid = user.uid;

      // 2. Sync with Backend (Firestore)
      // This solves the 'backend for multiple users' request.
      // We persist their preferences, DUPR ID, etc.
      await UserService().syncUser(user, role);

      // 3. Update State
      state = state.copyWith(
        isLoggedIn: true,
        role: role,
        userId: uid,
        isLoading: false,
      );

      // 4. Persist "Session Intent" locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', rememberMe);
      await prefs.setString('role', role.name); 

    } catch (e) {
      print("Login Failed: $e");
      state = state.copyWith(isLoading: false);
      // In a real app, set an error state here
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    state = const AuthState(isLoggedIn: false, isLoading: false);
  }

  void toggleMFA(bool value) {
    state = state.copyWith(hasPendingMFA: value);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
