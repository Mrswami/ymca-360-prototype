import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/remote_config/remote_config_service.dart';

import 'theme/ymca_theme.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/scheduler_screen.dart';
import 'screens/workouts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trainer_dashboard.dart';
import 'screens/manager_dashboard.dart';
import 'screens/classes_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/community_screen.dart';

import 'services/stripe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Stripe
  // Initialize Stripe (Mobile Only for now)
  if (!kIsWeb) {
    StripeService.instance.init();
  }
  
  final options = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: options);

  // Initialize Remote Config (Crashlytics would go here too)
  final container = ProviderContainer();
  final remoteConfig = container.read(remoteConfigProvider);
  try {
    await remoteConfig.initialize();
  } catch (e) {
    debugPrint("Remote Config Init Failed: $e");
  }

  runApp(UncontrolledProviderScope(
    container: container,
    child: const YMCAApp(),
  ));
}

class YMCAApp extends ConsumerWidget {
  const YMCAApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return MaterialApp(
        title: 'YMCA 360',
        theme: ymcaTheme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'YMCA 360',
      theme: ymcaTheme,
      home: authState.isLoggedIn 
          ? const MainShell() 
          : WelcomeScreen(
              onLogin: (remember) => ref.read(authProvider.notifier).loginAsMember(rememberMe: remember),
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  List<Widget> _getScreens(UserRole role, String? userId) {
    switch (role) {
      case UserRole.member:
        return [
          const HomeScreen(),
          const SchedulerScreen(),
          const ClassesScreen(),
          const CommunityScreen(),
          const ProfileScreen(),
        ];
      case UserRole.trainer:
        return [
          const HomeScreen(),
          TrainerScheduleEditor(trainerId: userId ?? 't1'),
          const ProfileScreen(),
        ];
      case UserRole.manager:
        return [
          const ManagerDashboard(),
          const SchedulerScreen(),
          const ProfileScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getNavItems(UserRole role) {
    switch (role) {
      case UserRole.member:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Book PT'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
      case UserRole.trainer:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'My Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
        ];
      case UserRole.manager:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Admin'),
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showRoleSwitcher() {
    final authNotifier = ref.read(authProvider.notifier);
    final hasPendingMFA = ref.read(authProvider).hasPendingMFA;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Demo: Switch User Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Member View'),
            subtitle: const Text('James Moreno'),
            onTap: () {
              authNotifier.loginAsMember();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Trainer View'),
            subtitle: const Text('Sarah Connor (Instructor)'),
            onTap: () {
              authNotifier.loginAsTrainer();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Manager View'),
            subtitle: const Text('Admin Dashboard'),
            onTap: () {
              authNotifier.loginAsManager();
              Navigator.pop(context);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Simulate MFA Trigger'),
            subtitle: const Text('Toggle "Action Required" alert'),
            value: hasPendingMFA,
            activeColor: AppColors.ymcaBlue,
            onChanged: (val) {
              authNotifier.toggleMFA(val);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final screens = _getScreens(authState.role, authState.userId);
    final navItems = _getNavItems(authState.role);

    // Ensure index is valid after switching roles
    if (_selectedIndex >= screens.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.black87,
        child: const Icon(Icons.swap_horiz, color: Colors.white),
        onPressed: _showRoleSwitcher,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
