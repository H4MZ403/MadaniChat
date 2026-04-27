import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_contact.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/models/friend_request.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final chatRepository = ChatRepository();
  final emailController = TextEditingController();
  bool isSendingRequest = false;
  bool showAddFriend = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendFriendRequest() async {
    setState(() {
      isSendingRequest = true;
    });

    try {
      await chatRepository.sendFriendRequest(emailController.text);
      emailController.clear();
      if (!mounted) return;
      _showMessage('Friend request sent.');
      setState(() {
        showAddFriend = false;
      });
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString().replaceFirst('Invalid argument(s): ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isSendingRequest = false;
        });
      }
    }
  }

  Future<void> acceptRequest(FriendRequest request) async {
    try {
      await chatRepository.acceptFriendRequest(request);
      if (!mounted) return;
      _showMessage('Friend request accepted.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> declineRequest(FriendRequest request) async {
    try {
      await chatRepository.declineFriendRequest(request);
      if (!mounted) return;
      _showMessage('Friend request declined.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> openChat(Contact contact) async {
    try {
      final chatId = await chatRepository.openChatWithContact(contact);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(contact: contact, chatId: chatId),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> confirmDeleteContact(Contact contact) async {
    final shouldDelete = await _showDeleteContactDialog(contact);
    if (shouldDelete != true) {
      return;
    }

    try {
      await chatRepository.deleteContact(contact);
      if (!mounted) return;
      _showMessage('${contact.username} was removed from your contacts.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<bool?> _showDeleteContactDialog(Contact contact) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: boxShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: lightRed,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0X4DFF7777),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.person_remove_alt_1_rounded,
                    color: red,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Delete contact?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: customGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${contact.username} will be removed from both contact lists.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: lightGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: MyButton(
                          title: 'Cancel',
                          fontSize: 15,
                          color: lightRed,
                          shadowEnabled: false,
                          fontColor: fontColor,
                          border: Border.all(color: strokeColor, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, true),
                        child: MyButton(
                          title: 'Delete',
                          fontSize: 15,
                          color: lightRed,
                          shadowEnabled: false,
                          fontColor: red,
                          border: Border.all(
                            color: const Color(0X4DFF7777),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Contacts',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _AddFriendToggleButton(
                  isOpen: showAddFriend,
                  onTap: () {
                    setState(() {
                      showAddFriend = !showAddFriend;
                    });
                  },
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAddFriend
                ? _AddFriendCard(
                    key: const ValueKey('add-friend-card'),
                    controller: emailController,
                    isSending: isSendingRequest,
                    onSend: sendFriendRequest,
                  )
                : const SizedBox.shrink(key: ValueKey('add-friend-empty')),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 95),
              children: [
                _IncomingRequestsSection(
                  stream: chatRepository.watchIncomingFriendRequests(),
                  onAccept: acceptRequest,
                  onDecline: declineRequest,
                ),
                _ContactsSection(
                  stream: chatRepository.watchContacts(),
                  onOpenChat: openChat,
                  onDeleteContact: confirmDeleteContact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddFriendToggleButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _AddFriendToggleButton({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isOpen ? 'Close add friend' : 'Add friend',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.yellow[500],
            borderRadius: BorderRadius.circular(12),
            boxShadow: boxShadow,
          ),
          child: Icon(
            isOpen ? Icons.close : Icons.person_add_alt_1,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _AddFriendCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _AddFriendCard({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add friend by email',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: customGrey,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) {
              if (!isSending) {
                onSend();
              }
            },
            decoration: InputDecoration(
              hintText: 'friend@example.com',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: isSending ? null : onSend,
            child: MyButton(
              title: isSending ? 'Sending...' : 'Send Request',
              fontSize: 16,
              color: Colors.yellow[500],
              shadowEnabled: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingRequestsSection extends StatelessWidget {
  final Stream<List<FriendRequest>> stream;
  final ValueChanged<FriendRequest> onAccept;
  final ValueChanged<FriendRequest> onDecline;

  const _IncomingRequestsSection({
    required this.stream,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FriendRequest>>(
      stream: stream,
      builder: (context, snapshot) {
        final requests = snapshot.data ?? [];
        if (requests.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Friend Requests (${requests.length})'),
            const SizedBox(height: 9),
            ...requests.map(
              (request) => _FriendRequestTile(
                request: request,
                onAccept: () => onAccept(request),
                onDecline: () => onDecline(request),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

class _FriendRequestTile extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _FriendRequestTile({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 10),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('lib/assets/avatar.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.fromDisplayName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: customGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  request.fromEmail,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withValues(alpha: 77),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _RequestActionButton(
                        title: 'Decline',
                        color: lightRed,
                        textColor: red,
                        borderColor: const Color(0X4DFF7777),
                        onTap: onDecline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RequestActionButton(
                        title: 'Accept',
                        color: Colors.yellow[500]!,
                        textColor: Colors.black,
                        borderColor: Colors.yellow.shade600,
                        onTap: onAccept,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _RequestActionButton({
    required this.title,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.judson(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactsSection extends StatelessWidget {
  final Stream<List<Contact>> stream;
  final ValueChanged<Contact> onOpenChat;
  final ValueChanged<Contact> onDeleteContact;

  const _ContactsSection({
    required this.stream,
    required this.onOpenChat,
    required this.onDeleteContact,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Contact>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _StateText(text: 'Unable to load contacts.', color: red);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final contacts = snapshot.data ?? [];
        if (contacts.isEmpty) {
          return const _StateText(
            text: 'No contacts yet. Send a friend request by email.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('All Contacts (${contacts.length})'),
            const SizedBox(height: 9),
            ...contacts.map(
              (contact) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ContactWidget(
                  contact: contact,
                  onTap: () => onOpenChat(contact),
                  onDelete: () => onDeleteContact(contact),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, top: 8),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 16,
          color: customGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StateText extends StatelessWidget {
  final String text;
  final Color? color;

  const _StateText({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          color: color ?? customGrey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
