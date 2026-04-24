import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class MyTopBar extends StatelessWidget {
  const MyTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'User';

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Madani',
              style: GoogleFonts.judson(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    style: GoogleFonts.judson(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: 'Hello '),
                      TextSpan(
                        text: name,
                        style: TextStyle(color: iris_100),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/avatar.jpg'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
