import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../utils/utils.dart';

class RegisterPage extends StatefulWidget {
  final void Function() onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome On Board',
                  style: GoogleFonts.judson(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Join us for instant conversations and a world of new connections at your fingertips',
                  style: GoogleFonts.judson(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 75,
                ),
                Column(
                  children: [
                    Container(
                      // margin: const EdgeInsets.symmetric(
                      //   horizontal: 40,
                      // ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: boxShadow,
                      ),
                      child: Column(
                        children: [
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            obsecureText: false,
                          ),
                          Divider(
                            color: grey,
                          ),
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
                          Divider(
                            color: grey,
                          ),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            obsecureText: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Sign Up Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home_page');
                      },
                      child: MyButton(
                        title: 'Sign Up',
                        fontSize: 22,
                        color: Colors.yellow[500],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'You already have an account?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            ' Sign in',
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
      ),
    );
  }
}
