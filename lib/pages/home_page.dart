import 'package:chat_app/components/top_bar.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../utils/colors.dart';
import 'contact_page.dart';
import 'setting_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // this selected index is to control  the bottom nav bar
  int _selectedIndex = 0;

  // this method will update our selected index
  // when the user taps on the bottom bar
  void navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages of display
  final List<Widget> _pages = [
    const MessagesPage(),
    const ContactPage(),
    const SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: secondGradient,
        ),
        child: Column(
          children: [
            /*
                  T O P   B A R
                */
            const MyTopBar(),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _pages[_selectedIndex],
                  /*
                    N A V   B A R
                  */
                  Positioned(
                    bottom: 15,
                    child: MyBottomNavBar(
                      onTabChange: (index) => navigationBottomBar(index),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
