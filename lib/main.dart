import 'package:chat_app/pages/auth_page.dart';
import 'package:chat_app/pages/home_page.dart';
// import 'package:chat_app/firebase_options.dart';
// import 'package:chat_app/pages/messages_page.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/pages/start_page.dart';
import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartPage(),
      // route of all the pages
      routes: {
        '/auth_page': (context) => const AuthPage(),
        '/home_page': (context) => const Homepage(),
      },
    );
  }
}
