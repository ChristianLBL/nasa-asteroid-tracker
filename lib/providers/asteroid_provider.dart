import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/asteroid.dart';
import '../services/asteroid_service.dart';

class AsteroidProvider with ChangeNotifier {
  final AsteroidService _asteroidService = AsteroidService();
  
  Map<String, List<Asteroid>> _feedAsteroids = {};
  List<Asteroid> _browseAsteroidsList = [];
  Asteroid? _selectedAsteroid;
  bool _isLoading = false;
  String? _error;

  Map<String, List<Asteroid>> get feedAsteroids => _feedAsteroids;
  List<Asteroid> get browseAsteroids => _browseAsteroidsList;
  Asteroid? get selectedAsteroid => _selectedAsteroid;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFeed({String? startDate, String? endDate}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final formattedStartDate = startDate ?? DateFormat('yyyy-MM-dd').format(now);
      final formattedEndDate = endDate ?? 
          DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 7)));
      
      _feedAsteroids = await _asteroidService.getFeed(
        formattedStartDate,
        formattedEndDate,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchAsteroid(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedAsteroid = await _asteroidService.getAsteroid(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchBrowseAsteroids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _browseAsteroidsList = await _asteroidService.browseAsteroids();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearSelectedAsteroid() {
    _selectedAsteroid = null;
    notifyListeners();
  }
}
