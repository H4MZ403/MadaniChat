import 'package:chat_app/models/contact.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ContactWidget({
    super.key,
    required this.contact,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: boxShadow,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 7),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(contact.imagePath)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.username,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: customGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    contact.email.isNotEmpty ? contact.email : contact.about,
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
            Icon(
              Icons.chevron_right,
              color: Colors.black.withValues(alpha: 64),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: 'Delete contact',
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: lightRed,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0X4DFF7777),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
