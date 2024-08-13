import 'package:flutter/material.dart';

import 'src/color.dart';
import 'calendar/calendar_page.dart';
import 'danchu/danchu_page.dart';
import 'profile/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const CalendarPage(),
    const DanchuPage(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.danchuYellow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Image.asset('assets/calendar-act.png', width: 24, height: 24),
            selectedIcon:
                Image.asset('assets/calendar-act.png', width: 24, height: 24),
            label: 'calendar',
          ),
          NavigationDestination(
            icon: Image.asset('assets/Danchu-act.png', width: 24, height: 24),
            selectedIcon:
                Image.asset('assets/Danchu-act.png', width: 24, height: 24),
            label: 'danchu',
          ),
          NavigationDestination(
            icon: Image.asset('assets/profile-act.png', width: 24, height: 24),
            selectedIcon:
                Image.asset('assets/profile-act.png', width: 24, height: 24),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
