import 'package:chat_app/components/my_contact.dart';
import 'package:chat_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_search_bar.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // list of pinned messages
  List<Contact> frequentlyContacted = [
    Contact(
      'lib/assets/avataaars.png',
      'Morad',
      'Hello! Catch me on MadaniChat',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars2.png',
      'Oussama',
      'Let\'s make it history',
      DateTime.now(),
    ),
  ];

  // list of all other messages
  List<Contact> allContact = [
    Contact(
      'lib/assets/avataaars.png',
      'Adil',
      'dlhul dkhul fifa nl3bu, bax nentaqem',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'Abdelhadi',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
    Contact(
      'lib/assets/avataaars.png',
      'XOXO',
      'You: Xoof victoria maxi dik abo mariam...',
      DateTime.now(),
    ),
  ];

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
                    'Contact',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*
                      F R E Q U E N T L Y   C O N T A C T E D
                    */
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 8),
                          child: Text(
                            'Frequently Contacted',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: customGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 9),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: frequentlyContacted.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ContactWidget(
                                  contact: frequentlyContacted[index],
                                ),
                                if (index < frequentlyContacted.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                        /*
                    A L L   C O N T A C T
                    */
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 22, top: 8),
                          child: Text(
                            'All Contact',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: customGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 9),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allContact.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ContactWidget(
                                  contact: allContact[index],
                                ),
                                if (index < allContact.length - 1)
                                  const SizedBox(height: 10),
                              ],
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
