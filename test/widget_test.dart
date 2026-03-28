import 'package:flutter_test/flutter_test.dart';
import 'package:tracer/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const TracerApp());
    expect(find.text('NAVIGATOR'), findsOneWidget);
  });
}
