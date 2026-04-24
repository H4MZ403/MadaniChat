import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;
  final String chatId;

  const ChatPage({
    super.key,
    required this.contact,
    required this.chatId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatRepository = ChatRepository();
  final messageController = TextEditingController();
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    chatRepository.markChatAsRead(widget.chatId);
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (isSending || messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await chatRepository.sendMessage(
        chatId: widget.chatId,
        text: messageController.text,
      );
      messageController.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: secondGradient),
        child: SafeArea(
          child: Column(
            children: [
              _ChatHeader(contact: widget.contact),
              const SizedBox(height: 14),
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
                    children: [
                      Expanded(
                        child: StreamBuilder<List<ChatMessage>>(
                          stream: chatRepository.watchMessages(widget.chatId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return _ChatStateText(
                                text: 'Unable to load messages.',
                                color: red,
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final messages = snapshot.data ?? [];
                            if (messages.isEmpty) {
                              return const _ChatStateText(
                                text: 'No messages yet. Say hello.',
                              );
                            }

                            return ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.fromLTRB(
                                15,
                                18,
                                15,
                                12,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return _MessageBubble(
                                  message: message,
                                  isMine: message.senderId == currentUid,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      _MessageComposer(
                        controller: messageController,
                        isSending: isSending,
                        onSend: sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final Contact contact;

  const _ChatHeader({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 15, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          CircleAvatar(backgroundImage: AssetImage(contact.imagePath)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.username,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: customGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  contact.email,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const _MessageBubble({
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? Colors.yellow[500] : Colors.yellow[50],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 2),
            bottomRight: Radius.circular(isMine ? 2 : 14),
          ),
          boxShadow: isMine ? null : boxShadow,
        ),
        child: Text(
          message.text,
          style: GoogleFonts.quicksand(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _MessageComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Message',
                  filled: true,
                  fillColor: Colors.yellow[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: strokeColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: strokeColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.yellow.shade700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: isSending ? null : onSend,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.yellow[500],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: boxShadow,
                ),
                child: const Icon(Icons.send, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatStateText extends StatelessWidget {
  final String text;
  final Color? color;

  const _ChatStateText({
    required this.text,
    this.color,
  });

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
