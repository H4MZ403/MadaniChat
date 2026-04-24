import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      constraints: const BoxConstraints(minHeight: 50),
      hintText: 'Search ...',
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: FeatherIcon(
          FeatherIcons.search,
          color: Colors.black.withValues(alpha: 77),
        ),
      ),
      hintStyle: WidgetStatePropertyAll(
        GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black.withValues(alpha: 77),
        ),
      ),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(4),
      shadowColor: WidgetStatePropertyAll(
        Colors.black.withValues(alpha: 128),
      ), // 50% opacity
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
