import 'package:chat_app/components/my_message.dart';
import 'package:chat_app/components/my_search_bar.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // list of pinned messages
  List<Message> pinnedMessages = [
    Message('lib/assets/avataaars.png', 'Morad', 'waa sahbi Dkhul Pubg',
        DateTime(2023, 1, 1, 12, 31), 3),
    Message('lib/assets/avataaars2.png', 'Oussama',
        'ana ghanqarra3, wa 3andek tsarre3', DateTime(2023, 1, 1, 14, 44), 1),
  ];
  // list of all other messages
  List<Message> allMessages = [
    Message(
        'lib/assets/avataaars.png',
        'Adil',
        'dlhul dkhul fifa nl3bu, bax nentaqem',
        DateTime(2023, 1, 1, 19, 50),
        4),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
    Message(
        'lib/assets/avataaars.png',
        'Abdelhadi',
        'You: Xoof victoria maxi dik abo mariam...',
        DateTime(2023, 1, 1, 10, 50),
        0),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // You have 8 New messages
        Text(
          'You have',
          style:
              GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          '8 New messages',
          style: GoogleFonts.quicksand(
            color: iris_100,
            decoration: TextDecoration.underline,
            decorationColor: iris_100,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
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
                    'Messages',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*
                    P I N N E D   M E S S A G E S
                    */
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 8),
                          child: Text(
                            'Pinned Message (4)',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: customGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pinnedMessages.length,
                          itemBuilder: (context, index) {
                            return MyMessage(
                              message: pinnedMessages[index],
                            );
                          },
                        ),
                        /*
                    A L L   M E S S A G E S
                    */
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 8),
                          child: Text(
                            'All Message (8)',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: customGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allMessages.length,
                          itemBuilder: (context, index) {
                            return MyMessage(
                              message: allMessages[index],
                            );
                          },
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
