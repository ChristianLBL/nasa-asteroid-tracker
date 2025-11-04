import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_asteroid_tracker/models/asteroid.dart';
import 'package:nasa_asteroid_tracker/widgets/asteroid_card.dart';

void main() {
  group('AsteroidCard Widget Tests', () {
    testWidgets('AsteroidCard displays asteroid name', (WidgetTester tester) async {
      final asteroid = Asteroid(
        id: '123',
        name: 'Test Asteroid',
        absoluteMagnitude: 20.0,
        estimatedDiameterMin: 0.1,
        estimatedDiameterMax: 0.2,
        isPotentiallyHazardous: false,
        closeApproachData: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsteroidCard(
              asteroid: asteroid,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Asteroid'), findsOneWidget);
    });

    testWidgets('AsteroidCard shows Hazardous badge for dangerous asteroids', 
        (WidgetTester tester) async {
      final asteroid = Asteroid(
        id: '456',
        name: 'Dangerous Asteroid',
        absoluteMagnitude: 19.0,
        estimatedDiameterMin: 0.5,
        estimatedDiameterMax: 1.0,
        isPotentiallyHazardous: true,
        closeApproachData: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsteroidCard(
              asteroid: asteroid,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Hazardous'), findsOneWidget);
    });

    testWidgets('AsteroidCard displays close approach data', 
        (WidgetTester tester) async {
      final closeApproach = CloseApproachData(
        closeApproachDate: '2024-01-15',
        closeApproachDateFull: '2024-Jan-15 10:30',
        relativeVelocity: 54000.5,
        missDistance: 7500000.25,
        orbitingBody: 'Earth',
      );

      final asteroid = Asteroid(
        id: '789',
        name: 'Close Asteroid',
        absoluteMagnitude: 21.0,
        estimatedDiameterMin: 0.2,
        estimatedDiameterMax: 0.4,
        isPotentiallyHazardous: false,
        closeApproachData: [closeApproach],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsteroidCard(
              asteroid: asteroid,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('15 Jan 2024'), findsOneWidget);
    });

    testWidgets('AsteroidCard calls onTap when tapped', 
        (WidgetTester tester) async {
      bool tapped = false;
      
      final asteroid = Asteroid(
        id: '999',
        name: 'Tappable Asteroid',
        absoluteMagnitude: 22.0,
        estimatedDiameterMin: 0.15,
        estimatedDiameterMax: 0.3,
        isPotentiallyHazardous: false,
        closeApproachData: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsteroidCard(
              asteroid: asteroid,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
