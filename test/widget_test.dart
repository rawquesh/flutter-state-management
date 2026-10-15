import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockapp/main.dart';

void main() {
  testWidgets('App renders State Management Lab home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StateManagementApp(),
      ),
    );

    // Verify header title exists
    expect(find.text('State Management Lab'), findsOneWidget);
    // Verify module titles exist (checking offstage for list items)
    expect(find.text('1. Provider'), findsOneWidget);
    expect(find.text('2. Riverpod 3'), findsOneWidget);
    expect(find.text('3. BLoC & Cubit', skipOffstage: false), findsOneWidget);
    expect(find.text('4. GetX', skipOffstage: false), findsOneWidget);
  });
}
