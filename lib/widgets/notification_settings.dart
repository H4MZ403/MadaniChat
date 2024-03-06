import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_container.dart';
import '../utils/colors.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*
          NOTIFICATION SETTINGS
        */
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 8),
          child: Text(
            'Notifications',
            style: GoogleFonts.quicksand(
                fontSize: 16, color: customGrey, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 9),
        /*
          CustomContainer contains my profile settings
        */
        CustomContainer(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 16, top: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column: Avatar, Name and About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Show Notications',
                    style: GoogleFonts.quicksand(
                      color: const Color(0XFF868686),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'ON',
                    style: GoogleFonts.quicksand(
                      color: green,
                    ),
                  ),
                ],
              ),
              // Column: Avatar, Name and About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sound',
                    style: GoogleFonts.quicksand(
                      color: const Color(0XFF868686),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Note',
                    style: GoogleFonts.quicksand(
                      color: const Color(0XFF333333),
                    ),
                  ),
                ],
              ),
              // Edit Icon
              IconButton(
                alignment: Alignment.centerRight,
                icon: FeatherIcon(
                  FeatherIcons.edit,
                  color: lightGrey,
                  size: 15,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
