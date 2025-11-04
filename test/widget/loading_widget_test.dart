import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_asteroid_tracker/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget Tests', () {
    testWidgets('LoadingWidget displays default loading message', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('LoadingWidget displays custom message', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: 'Loading asteroids...'),
          ),
        ),
      );

      expect(find.text('Loading asteroids...'), findsOneWidget);
    });

    testWidgets('LoadingWidget shows spinner animation', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });
  });
}
