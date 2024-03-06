import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMessage extends StatelessWidget {
  final Message message;
  const MyMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 17, right: 11, bottom: 13, top: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /* Avatar of the user */
                  CircleAvatar(
                    backgroundImage: AssetImage(message.imagePath),
                  ),
                  const SizedBox(width: 14),
                  // Column: Username & Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Username */
                      Text(
                        message.username,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /* Current Message */
                      Text(
                        message.currentMessage,
                        style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ],
              ),

              // Column: Message date & badge
              Column(
                children: [
                  // Date
                  Text(
                    '${message.dateTime.hour}:${message.dateTime.minute}',
                    style: GoogleFonts.judson(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  // Badge
                  Badge(
                    isLabelVisible: false,
                    child: Badge.count(
                      count: message.badgeCount,
                      backgroundColor: Colors.yellow[500],
                      textColor: Colors.black,
                      textStyle: GoogleFonts.judson(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
