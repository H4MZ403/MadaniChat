import 'package:chat_app/models/app_user.dart';
import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_container.dart';
import '../utils/colors.dart';

class ProfileWidget extends StatelessWidget {
  final AppUser user;
  final VoidCallback onEdit;

  const ProfileWidget({
    super.key,
    required this.user,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, top: 8),
          child: Text(
            'My Profile',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: customGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 9),
        CustomContainer(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 16,
            top: 7,
          ),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(user.photoPath)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: grey_333,
                      ),
                    ),
                    Text(
                      user.about,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: grey_333,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                alignment: Alignment.centerRight,
                icon: FeatherIcon(
                  FeatherIcons.edit,
                  color: lightGrey,
                  size: 15,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
