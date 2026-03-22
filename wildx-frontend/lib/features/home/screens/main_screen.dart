import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../profile/data/ranger_data.dart';
import '../../profile/models/ranger_model.dart';
import '../../profile/screens/edit_ranger_screen.dart';
import '../../profile/screens/explorer_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static void jumpTo(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainScreenState>()?.jumpTo(index);
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  late RangerModel _currentRanger;

  @override
  void initState() {
    super.initState();
    _currentRanger = _buildCurrentRanger();
  }

  RangerModel _buildCurrentRanger() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return kSampleRanger;

    return kSampleRanger.copyWith(
      name: user.displayName ??
          user.email?.split('@').first ??
          'Wildlife Explorer',
      email: user.email ?? user.phoneNumber ?? 'wildx@explorer.com',
      avatarUrl: user.photoURL,
    );
  }

  void _updateRanger(RangerModel updated) {
    setState(() => _currentRanger = updated);
  }

  List<Widget> get _screens => [
        ExplorerScreen(
          ranger: _currentRanger,
          onRangerUpdated: _updateRanger,
        ),
        const HomeScreen(),
        EditRangerScreen(
          ranger: _currentRanger,
          onSave: _updateRanger,
          popOnSave: false,
          showBackButton: false,
        ),
      ];

  void jumpTo(int index) {
    if (index < 0 || index >= _screens.length) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: jumpTo,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
