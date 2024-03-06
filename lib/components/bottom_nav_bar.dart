import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.yellow.shade500,
          width: 2,
        ),
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: GNav(
        padding: const EdgeInsets.all(15),
        color: Colors.black.withOpacity(0.4),
        activeColor: Colors.black,
        tabBackgroundColor: Colors.yellow.shade500,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
        mainAxisAlignment: MainAxisAlignment.center,
        onTabChange: (value) => onTabChange!(value),
        gap: 3,
        tabs: const [
          GButton(
            icon: Icons.chat_outlined,
            text: 'Message',
          ),
          GButton(
            icon: Icons.contact_page_outlined,
            text: 'Contact',
          ),
          GButton(
            icon: Icons.settings_outlined,
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}
