import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_container.dart';
import '../utils/colors.dart';

class SecurityWidget extends StatelessWidget {
  const SecurityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*
          SECURITY SETTINGS
        */
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 8),
          child: Text(
            'Security',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*
                Row: PASSWORD + EDIT BUTTON
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ROW: Avatar, Name and About
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.quicksand(
                          color: const Color(0XFF868686),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '*************',
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
              /*
                Column: TWO FACTOR AUTHENTICATION
              */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Two-Factor Authentication',
                    style: GoogleFonts.quicksand(
                      color: const Color(0XFF868686),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'ON (SMS)',
                    style: GoogleFonts.quicksand(
                      color: green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
