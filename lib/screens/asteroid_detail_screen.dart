import 'package:flutter/material.dart';
import '../models/asteroid.dart';
import '../utils/date_utils.dart' as date_util;
import '../utils/number_formatter.dart';
import 'space_compass_screen.dart'; // Nuovo import per la bussola spaziale

class AsteroidDetailScreen extends StatelessWidget {
  final Asteroid asteroid;
  const AsteroidDetailScreen({Key? key, required this.asteroid})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroid Details'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/space_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildPhysicalParameters(context),
                const SizedBox(height: 24),
                if (asteroid.closeApproachData.isNotEmpty)
                  _buildCloseApproachData(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpaceCompassScreen(asteroid: asteroid),
            ),
          );
        },
        backgroundColor:
            asteroid.isPotentiallyHazardous
                ? Colors.red.shade700
                : Colors.blue.shade700,
        child: const Icon(Icons.explore),
        tooltip: 'Space Compass',
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              asteroid.isPotentiallyHazardous
                  ? [Colors.red.shade900, Colors.red.shade700]
                  : [Colors.blue.shade900, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (asteroid.isPotentiallyHazardous)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Potentially Hazardous',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${asteroid.id}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalParameters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Physical Parameters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            'Absolute Magnitude',
            '${asteroid.absoluteMagnitude} H',
            Icons.brightness_7,
          ),
          const Divider(color: Colors.grey),
          _buildInfoRow(
            context,
            'Estimated Diameter',
            '${NumberFormatter.formatDistance(asteroid.estimatedDiameterMin)} - ${NumberFormatter.formatDistance(asteroid.estimatedDiameterMax)} km',
            Icons.straighten,
          ),
          const Divider(color: Colors.grey),
          _buildInfoRow(
            context,
            'Hazardous',
            asteroid.isPotentiallyHazardous ? 'Yes' : 'No',
            Icons.warning,
            valueColor:
                asteroid.isPotentiallyHazardous ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCloseApproachData(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Close Approach Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...asteroid.closeApproachData.map((approach) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    'Date',
                    date_util.DateUtils.formatDate(approach.closeApproachDate),
                    Icons.calendar_today,
                  ),
                  const Divider(color: Colors.grey),
                  _buildInfoRow(
                    context,
                    'Full Date',
                    approach.closeApproachDateFull,
                    Icons.access_time,
                  ),
                  const Divider(color: Colors.grey),
                  _buildInfoRow(
                    context,
                    'Relative Velocity',
                    '${NumberFormatter.formatVelocity(approach.relativeVelocity)} km/h',
                    Icons.speed,
                  ),
                  const Divider(color: Colors.grey),
                  _buildInfoRow(
                    context,
                    'Miss Distance',
                    '${NumberFormatter.formatDistance(approach.missDistance)} km',
                    Icons.social_distance,
                  ),
                  const Divider(color: Colors.grey),
                  _buildInfoRow(
                    context,
                    'Orbiting Body',
                    approach.orbitingBody,
                    Icons.public,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
