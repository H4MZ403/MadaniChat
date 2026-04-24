import 'package:chat_app/models/app_user.dart';
import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_container.dart';
import '../utils/colors.dart';

class SecurityWidget extends StatelessWidget {
  final AppUser user;
  final VoidCallback onEdit;

  const SecurityWidget({
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
            'Security',
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
            right: 8,
            bottom: 10,
            top: 7,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _SecurityRow(label: 'Email', value: user.email),
                    Divider(color: grey),
                    _SecurityRow(
                      label: 'Phone Number',
                      value: user.phoneNumber.isEmpty
                          ? 'Not set'
                          : user.phoneNumber,
                    ),
                    Divider(color: grey),
                    const _SecurityRow(
                      label: 'Password',
                      value: '*************',
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

class _SecurityRow extends StatelessWidget {
  final String label;
  final String value;

  const _SecurityRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.quicksand(
                  color: const Color(0XFF868686),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  color: const Color(0XFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
