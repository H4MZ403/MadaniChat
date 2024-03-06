import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_container.dart';
import '../utils/colors.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*
          M Y   P R O F I L E
        */
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 8),
          child: Text(
            'My Profile',
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
            children: [
              /*
                Row: AVATAR / NAME / ABOUT / EDIT ICON
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ROW: Avatar, Name and About
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('lib/assets/avatar.jpg'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hamza',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: grey_333,
                            ),
                          ),
                          Text(
                            'Hello! Catch me on MadaniChat',
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              color: grey_333,
                            ),
                          ),
                        ],
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
              const SizedBox(height: 17),
              /*
                Row: EMAIL / PHONE NUMBER
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.quicksand(
                          color: const Color(0XFF868686),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'hamza@gmail.com',
                        style: GoogleFonts.quicksand(
                            color: const Color(0XFF333333)),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 24),
                  // Phone Number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: GoogleFonts.quicksand(
                          color: const Color(0XFF868686),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '+212 000 00 00 00',
                        style: GoogleFonts.quicksand(
                            color: const Color(0XFF333333)),
                      ),
                    ],
                  ),
                  const SizedBox()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
