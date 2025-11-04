import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nasa_asteroid_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NASA Asteroid Tracker Integration Tests', () {
    testWidgets('Complete app flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('ASTEROID FEED'), findsOneWidget);

      await tester.tap(find.text('BROWSE'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('BROWSE ASTEROIDS'), findsOneWidget);

      await tester.tap(find.text('SEARCH'));
      await tester.pumpAndSettle();

      expect(find.text('SEARCH ASTEROID'), findsOneWidget);
    });

    testWidgets('Bottom navigation test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final feedTab = find.text('FEED');
      final browseTab = find.text('BROWSE');
      final searchTab = find.text('SEARCH');

      expect(feedTab, findsOneWidget);
      expect(browseTab, findsOneWidget);
      expect(searchTab, findsOneWidget);

      await tester.tap(browseTab);
      await tester.pumpAndSettle();

      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      await tester.tap(feedTab);
      await tester.pumpAndSettle();
    });

    testWidgets('Search screen input test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('SEARCH'));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, '3542519');
      await tester.pumpAndSettle();

      expect(find.text('3542519'), findsOneWidget);
    });

    testWidgets('Feed screen loads asteroids', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Browse screen pagination test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('BROWSE'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final forwardButton = find.byIcon(Icons.arrow_forward);
      if (forwardButton.evaluate().isNotEmpty) {
        await tester.tap(forwardButton);
        await tester.pumpAndSettle();

        expect(find.text('Page 2'), findsOneWidget);
      }
    });
  });
}
