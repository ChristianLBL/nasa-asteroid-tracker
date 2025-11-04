import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/asteroid.dart';

class AsteroidService {
  final String baseUrl = 'https://api.nasa.gov/neo/rest/v1';
  final String apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';

  Future<Map<String, List<Asteroid>>> getFeed(
      String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/feed?start_date=$startDate&end_date=$endDate&api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> nearEarthObjects = data['near_earth_objects'];
      
      Map<String, List<Asteroid>> result = {};
      
      nearEarthObjects.forEach((date, asteroids) {
        result[date] = List<Asteroid>.from(
          asteroids.map((x) => Asteroid.fromJson(x)),
        );
      });
      
      return result;
    } else {
      throw Exception('Failed to load asteroid feed: ${response.statusCode}');
    }
  }

  Future<Asteroid> getAsteroid(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/neo/$id?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Asteroid.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load asteroid: ${response.statusCode}');
    }
  }

  Future<List<Asteroid>> browseAsteroids() async {
    final response = await http.get(
      Uri.parse('$baseUrl/neo/browse?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<Asteroid>.from(
        data['near_earth_objects'].map((x) => Asteroid.fromJson(x)),
      );
    } else {
      throw Exception('Failed to browse asteroids: ${response.statusCode}');
    }
  }
}
