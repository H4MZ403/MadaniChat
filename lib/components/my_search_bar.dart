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
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      // set the controller later for the search functionality
      controller: TextEditingController(),
      hintStyle: MaterialStatePropertyAll(
        GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
      elevation: const MaterialStatePropertyAll(4),
      shadowColor: MaterialStatePropertyAll(Colors.black.withOpacity(0.5)),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
