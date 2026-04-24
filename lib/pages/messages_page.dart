import 'package:chat_app/components/my_message.dart';
import 'package:chat_app/components/my_search_bar.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/chat_repository.dart';
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
  final chatRepository = ChatRepository();

  void openChat(Message message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          contact: Contact(
            id: message.contactId,
            imagePath: message.imagePath,
            username: message.username,
            email: message.contactEmail,
            about: '',
            createdAt: message.dateTime,
          ),
          chatId: message.chatId,
        ),
      ),
    );
  }

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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
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
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    stream: chatRepository.watchChatSummaries(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _MessageStateText(
                          text: 'Unable to load messages.',
                          color: red,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data ?? [];
                      if (messages.isEmpty) {
                        return const _MessageStateText(
                          text: 'No chats yet. Add a friend to start one.',
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return MyMessage(
                            message: messages[index],
                            onTap: () => openChat(messages[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageStateText extends StatelessWidget {
  final String text;
  final Color? color;

  const _MessageStateText({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            color: color ?? customGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
