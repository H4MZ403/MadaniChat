import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = 1.0;
    if (screenSize.height < 770) {
      size = 0.8;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(gradient: firstGradient),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SvgPicture.asset(
                            'lib/assets/undraw_chatting.svg',
                            width: 100 * size,
                          ),
                        ),
                        SvgPicture.asset(
                          'lib/assets/undraw_quick_chat.svg',
                          width: 200 * size,
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'lib/assets/undraw_team_chat.svg',
                      height: 300 * size,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 220;
                    final titleSize = (compact ? 24 : 30) * size;
                    final bodySize = (compact ? 17 : 20) * size;
                    final verticalGap = (compact ? 10 : 20) * size;

                    return Padding(
                      padding: EdgeInsets.only(top: compact ? 16 : 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Breaking Silence,\nBuilding Connections',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.judson(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withValues(
                                alpha: 204,
                              ), // 80% opacity
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: verticalGap),
                          Text(
                            'Your journey into the next level of\n communication starts here!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.judson(
                              fontSize: bodySize,
                              height: 1.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withValues(
                                alpha: 153,
                              ), // 60% opacity
                            ),
                          ),
                          SizedBox(height: verticalGap),
                          FractionallySizedBox(
                            widthFactor: compact ? 0.42 : 0.45,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register_page',
                                );
                              },
                              child: MyButton(
                                title: 'Get Started',
                                fontSize: (compact ? 18 : 22) * size,
                                color: Colors.yellow[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
