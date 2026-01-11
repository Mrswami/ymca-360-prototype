import 'package:flutter/material.dart';

import 'theme/ymca_theme.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/scheduler_screen.dart';
import 'screens/workouts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trainer_dashboard.dart';
import 'screens/manager_dashboard.dart';
import 'screens/classes_screen.dart';

void main() {
  runApp(const YMCAApp());
}

class YMCAApp extends StatefulWidget {
  const YMCAApp({super.key});

  @override
  State<YMCAApp> createState() => _YMCAAppState();
}

class _YMCAAppState extends State<YMCAApp> {
  // Key to force rebuild app on logout
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      title: 'YMCA 360',
      theme: ymcaTheme,
      home: MainShell(onRestart: restartApp),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends StatefulWidget {
  final VoidCallback onRestart;
  const MainShell({super.key, required this.onRestart});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final AuthService _auth = AuthService();

  // Screen Lists per Role
  List<Widget> _getScreens() {
    switch (_auth.currentRole) {
      case UserRole.member:
        return [
          const HomeScreen(),
          const SchedulerScreen(),
          const ClassesScreen(),
          const ProfileScreen(),
        ];
      case UserRole.trainer:
        return [
          // Basic Home view but maybe slightly different? For now same home.
          const HomeScreen(), 
          TrainerScheduleEditor(trainerId: _auth.currentUserId ?? 't1'),
          const ProfileScreen(),
        ];
      case UserRole.manager:
        return [
          const ManagerDashboard(), // Dashboard is home for manager
          const SchedulerScreen(), // To view bookings
          const ProfileScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getNavItems() {
    switch (_auth.currentRole) {
      case UserRole.member:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Book PT'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: 'Classes'),
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

  // Demo functionality to switch roles
  void _showRoleSwitcher() {
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
              _auth.loginAsMember('m1');
              _reload();
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Trainer View'),
            subtitle: const Text('Sarah Connor (Instructor)'),
            onTap: () {
              _auth.loginAsTrainer('t1');
              _reload();
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Manager View'),
            subtitle: const Text('Admin Dashboard'),
            onTap: () {
              _auth.loginAsManager();
              _reload();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Simulate MFA Trigger'),
            subtitle: const Text('Toggle "Action Required" alert'),
            value: _auth.hasPendingMFA, 
            activeColor: AppColors.ymcaBlue,
            onChanged: (val) {
              _auth.hasPendingMFA = val;
              _reload();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _reload() {
    Navigator.pop(context);
    widget.onRestart();
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();
    final navItems = _getNavItems();

    // Ensure index is valid after switching roles (some roles have fewer tabs)
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
      // Floating button to switch roles for DEMO purposes
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
