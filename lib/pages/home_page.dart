import 'dart:async';

import 'package:chat_app/components/top_bar.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:chat_app/services/chat_repository.dart';
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
  final chatRepository = ChatRepository();
  StreamSubscription<int>? _friendRequestCountSubscription;
  StreamSubscription<int>? _unreadMessageCountSubscription;

  // this selected index is to control  the bottom nav bar
  int _selectedIndex = 0;
  int _contactRequestCount = 0;
  int _messageUnreadCount = 0;

  @override
  void initState() {
    super.initState();
    _friendRequestCountSubscription = chatRepository
        .watchIncomingFriendRequestCount()
        .listen((count) {
          if (!mounted) return;
          setState(() {
            _contactRequestCount = count;
          });
        });
    _unreadMessageCountSubscription = chatRepository
        .watchUnreadMessageCount()
        .listen((count) {
          if (!mounted) return;
          setState(() {
            _messageUnreadCount = count;
          });
        });
  }

  @override
  void dispose() {
    _friendRequestCountSubscription?.cancel();
    _unreadMessageCountSubscription?.cancel();
    super.dispose();
  }

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
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: secondGradient),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, right: 15, left: 15),
            child: Column(
              children: [
                const MyTopBar(),
                const SizedBox(height: 18),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _pages[_selectedIndex],
                      Positioned(
                        bottom: 15,
                        child: MyBottomNavBar(
                          selectedIndex: _selectedIndex,
                          messageUnreadCount: _messageUnreadCount,
                          contactRequestCount: _contactRequestCount,
                          onTabChange: (index) => navigationBottomBar(index),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
