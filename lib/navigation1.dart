
import 'package:allobaay/chart1.dart';
import 'package:allobaay/chat.dart';
import 'package:allobaay/home.dart';
import 'package:allobaay/home1.dart';
import 'package:allobaay/services_page.dart';
import 'package:allobaay/settings.dart';
import 'package:flutter/material.dart';

class MainNavigation1 extends StatefulWidget {
  @override
  _MainNavigation1State createState() => _MainNavigation1State();
}

class _MainNavigation1State extends State<MainNavigation1> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage1(),
    // ServicesPage(),
    ChatPage1(),
    SettingsPage(),
    // ServicesPage(),
    // ChatPage(),
    // SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFE75480),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.medical_services),
          //   label: 'Services',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
