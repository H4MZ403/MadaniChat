import 'package:chat_app/models/contact.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  const ContactWidget({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.yellow[50],
            borderRadius: BorderRadius.circular(12),
            boxShadow: boxShadow,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /* Avatar of the user */
                  CircleAvatar(
                    backgroundImage: AssetImage(contact.imagePath),
                  ),
                  const SizedBox(width: 14),
                  // Column: Username & Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Username */
                      Text(
                        contact.username,
                        style: GoogleFonts.quicksand(
                          color: customGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      /* Current Message */
                      Text(
                        contact.about,
                        style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
