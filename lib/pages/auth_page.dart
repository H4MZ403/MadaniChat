import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  final bool showRegisterFirst;

  const AuthPage({super.key, this.showRegisterFirst = false});

  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Firebase is not configured for this platform.'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return const _ProfileGate();
          }

          return LoginOrRegisterPage(showRegisterFirst: showRegisterFirst);
        },
      ),
    );
  }
}

class _ProfileGate extends StatefulWidget {
  const _ProfileGate();

  @override
  State<_ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<_ProfileGate> {
  late final Future<void> profileFuture = ChatRepository()
      .ensureCurrentUserProfile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return const Homepage();
      },
    );
  }
}
