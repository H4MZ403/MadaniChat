import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chat_app/main.dart';

void main() {
  testWidgets('shows the start page', (WidgetTester tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;

    await tester.pumpWidget(const MyApp());

    expect(
      find.text('Breaking Silence,\nBuilding Connections'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
  });
}
