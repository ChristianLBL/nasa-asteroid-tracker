class Asteroid {
  final String id;
  final String name;
  final double absoluteMagnitude;
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;
  final bool isPotentiallyHazardous;
  final List<CloseApproachData> closeApproachData;

  Asteroid({
    required this.id,
    required this.name,
    required this.absoluteMagnitude,
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
    required this.isPotentiallyHazardous,
    required this.closeApproachData,
  });

  factory Asteroid.fromJson(Map<String, dynamic> json) {
    List<CloseApproachData> closeApproachDataList = [];
    if (json['close_approach_data'] != null) {
      closeApproachDataList = List<CloseApproachData>.from(
        json['close_approach_data'].map(
          (x) => CloseApproachData.fromJson(x),
        ),
      );
    }

    return Asteroid(
      id: json['id'],
      name: json['name'],
      absoluteMagnitude: json['absolute_magnitude_h'].toDouble(),
      estimatedDiameterMin: json['estimated_diameter']['kilometers']
              ['estimated_diameter_min']
          .toDouble(),
      estimatedDiameterMax: json['estimated_diameter']['kilometers']
              ['estimated_diameter_max']
          .toDouble(),
      isPotentiallyHazardous:
          json['is_potentially_hazardous_asteroid'] ?? false,
      closeApproachData: closeApproachDataList,
    );
  }
}

class CloseApproachData {
  final String closeApproachDate;
  final String closeApproachDateFull;
  final double relativeVelocity;
  final double missDistance;
  final String orbitingBody;

  CloseApproachData({
    required this.closeApproachDate,
    required this.closeApproachDateFull,
    required this.relativeVelocity,
    required this.missDistance,
    required this.orbitingBody,
  });

  factory CloseApproachData.fromJson(Map<String, dynamic> json) {
    return CloseApproachData(
      closeApproachDate: json['close_approach_date'],
      closeApproachDateFull: json['close_approach_date_full'],
      relativeVelocity: double.parse(
          json['relative_velocity']['kilometers_per_hour']),
      missDistance: double.parse(json['miss_distance']['kilometers']),
      orbitingBody: json['orbiting_body'],
    );
  }
}
