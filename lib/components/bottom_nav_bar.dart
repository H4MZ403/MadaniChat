import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int selectedIndex;
  final int messageUnreadCount;
  final int contactRequestCount;

  const MyBottomNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
    this.messageUnreadCount = 0,
    this.contactRequestCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.yellow.shade500, width: 2),
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: GNav(
        key: ValueKey(
          'bottom-nav-$selectedIndex-$messageUnreadCount-$contactRequestCount',
        ),
        selectedIndex: selectedIndex,
        padding: const EdgeInsets.all(15),
        color: Colors.black.withValues(alpha: 102), // 40% opacity
        activeColor: Colors.black,
        tabBackgroundColor: Colors.yellow.shade500,
        textStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
        mainAxisAlignment: MainAxisAlignment.center,
        onTabChange: (value) => onTabChange!(value),
        gap: 3,
        tabs: [
          GButton(
            icon: Icons.chat_outlined,
            text: 'Message',
            leading: _NavIconWithBadge(
              icon: Icons.chat_outlined,
              count: selectedIndex == 0 ? 0 : messageUnreadCount,
              color: selectedIndex == 0
                  ? Colors.black
                  : Colors.black.withValues(alpha: 102),
            ),
          ),
          GButton(
            icon: Icons.contact_page_outlined,
            text: 'Contact',
            leading: _NavIconWithBadge(
              icon: Icons.contact_page_outlined,
              count: selectedIndex == 1 ? 0 : contactRequestCount,
              color: selectedIndex == 1
                  ? Colors.black
                  : Colors.black.withValues(alpha: 102),
            ),
          ),
          const GButton(icon: Icons.settings_outlined, text: 'Settings'),
        ],
      ),
    );
  }
}

class _NavIconWithBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _NavIconWithBadge({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = count > 99 ? '99+' : count.toString();

    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: Icon(icon, color: color)),
          if (count > 0)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    visibleCount,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
