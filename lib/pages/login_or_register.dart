import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final bool showRegisterFirst;

  const LoginOrRegisterPage({super.key, this.showRegisterFirst = false});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  late bool showLoginPage;

  @override
  void initState() {
    super.initState();
    showLoginPage = !widget.showRegisterFirst;
  }

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
