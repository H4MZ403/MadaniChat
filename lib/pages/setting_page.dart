import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/widgets/my_profile.dart';
import 'package:chat_app/widgets/notification_settings.dart';
import 'package:chat_app/widgets/security_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_search_bar.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MySearchBar(),
        const SizedBox(height: 15),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: boxShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15),
                  child: Text(
                    'Settings',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 580,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const ProfileWidget(),
                        /*
                            S E C U R I T Y
                        */
                        const SizedBox(height: 20),
                        const SecurityWidget(),
                        /*
                          N O T I F I C A T I O N
                        */
                        const SizedBox(height: 20),
                        const NotificationWidget(),
                        /*
                          D E L E T E   B U T T O N
                        */
                        const SizedBox(height: 20),
                        // LOGOUT BUTTON
                        GestureDetector(
                          // implement the functionality later
                          onTap: () {},
                          child: MyButton(
                            title: 'Log out',
                            fontSize: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            color: lightRed,
                            shadowEnabled: false,
                            fontColor: fontColor,
                            border: Border.all(
                              color: strokeColor,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // DELETE ACCOUNT BUTTON
                        GestureDetector(
                          // implement the functionality later
                          onTap: () {},
                          child: MyButton(
                            title: 'Delete Account',
                            fontSize: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            color: lightRed,
                            shadowEnabled: false,
                            fontColor: red,
                            border: Border.all(
                              color: const Color(0X4DFF7777),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
