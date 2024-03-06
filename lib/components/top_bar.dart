import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class MyTopBar extends StatelessWidget {
  const MyTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // left row of the nav-bar
        Row(
          children: [
            Text(
              'Madani',
              style:
                  GoogleFonts.judson(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Chat',
              style: GoogleFonts.judson(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iris_100,
              ),
            ),
          ],
        ),
        // right row of the nav-bar
        Row(
          children: [
            Text(
              'Hello',
              style:
                  GoogleFonts.judson(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),

            // name of the user
            Text(
              'Hamza',
              style: GoogleFonts.judson(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iris_100,
              ),
            ),
            const SizedBox(width: 10),

            // avatar of the user
            const SizedBox(
              height: 30,
              width: 30,
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/avatar.jpg'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
