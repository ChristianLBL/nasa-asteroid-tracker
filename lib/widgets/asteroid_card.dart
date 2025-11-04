import 'package:flutter/material.dart';
import '../models/asteroid.dart';
import '../utils/date_utils.dart' as date_util;
import '../utils/number_formatter.dart';

class AsteroidCard extends StatelessWidget {
  final Asteroid asteroid;
  final VoidCallback onTap;

  const AsteroidCard({Key? key, required this.asteroid, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final closeApproach =
        asteroid.closeApproachData.isNotEmpty
            ? asteroid.closeApproachData.first
            : null;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors:
                  asteroid.isPotentiallyHazardous
                      ? [Colors.red.shade900, Colors.red.shade700]
                      : [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      asteroid.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (asteroid.isPotentiallyHazardous)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Hazardous',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.straighten, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Diameter: ${NumberFormatter.formatDistance(asteroid.estimatedDiameterMin)} - ${NumberFormatter.formatDistance(asteroid.estimatedDiameterMax)} km',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              if (closeApproach != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Approach: ${date_util.DateUtils.formatDate(closeApproach.closeApproachDate)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Speed: ${NumberFormatter.formatVelocity(closeApproach.relativeVelocity)} km/h',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.social_distance,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Miss Distance: ${NumberFormatter.formatDistance(closeApproach.missDistance)} km',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
