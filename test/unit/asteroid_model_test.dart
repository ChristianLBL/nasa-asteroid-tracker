import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_asteroid_tracker/models/asteroid.dart';

void main() {
  group('Asteroid Model Tests', () {
    test('Asteroid.fromJson should parse JSON correctly', () {
      final json = {
        'id': '3542519',
        'name': '(2010 PK9)',
        'absolute_magnitude_h': 21.3,
        'estimated_diameter': {
          'kilometers': {
            'estimated_diameter_min': 0.134,
            'estimated_diameter_max': 0.3
          }
        },
        'is_potentially_hazardous_asteroid': true,
        'close_approach_data': [
          {
            'close_approach_date': '2024-01-15',
            'close_approach_date_full': '2024-Jan-15 10:30',
            'relative_velocity': {
              'kilometers_per_hour': '54000.5'
            },
            'miss_distance': {
              'kilometers': '7500000.25'
            },
            'orbiting_body': 'Earth'
          }
        ]
      };

      final asteroid = Asteroid.fromJson(json);

      expect(asteroid.id, '3542519');
      expect(asteroid.name, '(2010 PK9)');
      expect(asteroid.absoluteMagnitude, 21.3);
      expect(asteroid.estimatedDiameterMin, 0.134);
      expect(asteroid.estimatedDiameterMax, 0.3);
      expect(asteroid.isPotentiallyHazardous, true);
      expect(asteroid.closeApproachData.length, 1);
    });

    test('CloseApproachData.fromJson should parse JSON correctly', () {
      final json = {
        'close_approach_date': '2024-01-15',
        'close_approach_date_full': '2024-Jan-15 10:30',
        'relative_velocity': {
          'kilometers_per_hour': '54000.5'
        },
        'miss_distance': {
          'kilometers': '7500000.25'
        },
        'orbiting_body': 'Earth'
      };

      final closeApproach = CloseApproachData.fromJson(json);

      expect(closeApproach.closeApproachDate, '2024-01-15');
      expect(closeApproach.closeApproachDateFull, '2024-Jan-15 10:30');
      expect(closeApproach.relativeVelocity, 54000.5);
      expect(closeApproach.missDistance, 7500000.25);
      expect(closeApproach.orbitingBody, 'Earth');
    });

    test('Asteroid with empty close_approach_data should work', () {
      final json = {
        'id': '123',
        'name': 'Test Asteroid',
        'absolute_magnitude_h': 20.0,
        'estimated_diameter': {
          'kilometers': {
            'estimated_diameter_min': 0.1,
            'estimated_diameter_max': 0.2
          }
        },
        'is_potentially_hazardous_asteroid': false,
        'close_approach_data': null
      };

      final asteroid = Asteroid.fromJson(json);

      expect(asteroid.closeApproachData.isEmpty, true);
    });
  });
}
