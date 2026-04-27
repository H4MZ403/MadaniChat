import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMessage extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;

  const MyMessage({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 17, right: 11, bottom: 13, top: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(message.imagePath)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.username,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          message.currentMessage,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withValues(alpha: 77),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  _formatTime(message.dateTime),
                  style: GoogleFonts.judson(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black.withValues(alpha: 77),
                  ),
                ),
                if (message.badgeCount > 0)
                  Badge.count(
                    count: message.badgeCount,
                    backgroundColor: Colors.yellow[500],
                    textColor: Colors.black,
                    textStyle: GoogleFonts.judson(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
