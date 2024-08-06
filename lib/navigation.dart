import 'package:danchu/calendar/calendar.dart';
import 'package:flutter/material.dart';

import 'src/color.dart';
import 'calendar/calendar_page.dart';
import 'danchu/danchu_page.dart';
import 'setting/setting.dart';

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
    const SettingApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 선택된 인덱스에 해당하는 페이지 표시
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.danchuYellow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.folder),
            icon: Icon(Icons.folder),
            label: 'calendar',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'danchu',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
