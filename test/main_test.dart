import 'package:flutter_test/flutter_test.dart';
import 'package:tft_cheatsheet_app/main.dart';

void main() {
  testWidgets('Initial screen is Items Tab', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Base Items'), findsOneWidget);
    expect(find.text('Combined Items'), findsOneWidget);
  });
}
