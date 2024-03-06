import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_textfield.dart';
import '../utils/utils.dart';

class SignInPage extends StatefulWidget {
  final void Function() onTap;

  const SignInPage({
    super.key,
    required this.onTap,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = 3;
    if (screenSize.height < 770) {
      size = 2;
    }
    if (screenSize.height < 700) {
      size = 1;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(top: 33 * size),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: secondGradient),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Welcome Back',
                  style: GoogleFonts.judson(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  'lib/assets/undraw_chat.svg',
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: boxShadow,
                    ),
                    child: Column(
                      children: [
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obsecureText: false,
                        ),
                        Divider(
                          color: grey,
                        ),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obsecureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    // Sign In button
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home_page');
                      },
                      child: MyButton(
                        title: 'Sign In',
                        fontSize: 22,
                        color: Colors.yellow[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          ' Register Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: iris_100,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
