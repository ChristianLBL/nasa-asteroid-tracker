import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;
import '../models/asteroid.dart';
import 'package:flutter_compass/flutter_compass.dart';

class SpaceCompassScreen extends StatefulWidget {
  final Asteroid asteroid;

  const SpaceCompassScreen({Key? key, required this.asteroid})
    : super(key: key);

  @override
  State<SpaceCompassScreen> createState() => _SpaceCompassScreenState();
}

class _SpaceCompassScreenState extends State<SpaceCompassScreen> {
  StreamSubscription<CompassEvent>? _compassSubscription;

  double _heading = 0;
  double _lastHeading = 0;

  late double _asteroidAzimuth;

  late double _asteroidDistance;

  bool _isCalibrating = true;
  bool _hasCompass = false;

  @override
  void initState() {
    super.initState();

    // Verifica se il dispositivo ha una bussola
    FlutterCompass.events?.listen((event) {
      setState(() {
        _hasCompass = true;
      });
    });

    // Genera una posizione casuale per l'asteroide
    final random = math.Random();
    _asteroidAzimuth = random.nextDouble() * 360; // -90 a 90 gradi

    // Calcola una distanza simulata basata sulla distanza reale dell'asteroide
    if (widget.asteroid.closeApproachData.isNotEmpty) {
      final missDistance = widget.asteroid.closeApproachData.first.missDistance;
      // Normalizza la distanza per la visualizzazione
      _asteroidDistance = math.min(missDistance / 1000000, 100);
    } else {
      _asteroidDistance = 50 + random.nextDouble() * 50; // 50-100 unità
    }

    // Inizia la calibrazione e poi avvia i sensori
    _startCompass();
  }

  void _startCompass() {
    setState(() {
      _isCalibrating = true;
    });

    // Avvia il sensore della bussola
    _compassSubscription?.cancel();

    if (FlutterCompass.events != null) {
      _compassSubscription = FlutterCompass.events!.listen((
        CompassEvent event,
      ) {
        if (event.heading != null) {
          final newHeading = event.heading!;
          
          if ((newHeading - _lastHeading).abs() > 2) {
            setState(() {
              _heading = newHeading;
              _lastHeading = newHeading;

              if (_isCalibrating &&
                  event.accuracy != null &&
                  event.accuracy! <= 2) {
                _isCalibrating = false;
              }
            });
          }
        }
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (_isCalibrating) {
          setState(() {
            _isCalibrating = false;
          });
        }
      });
    } else {
      setState(() {
        _isCalibrating = false;
        _hasCompass = false;
      });
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  // Calcola la differenza tra la direzione del dispositivo e l'asteroide
  double _getDirectionDifference() {
    final diff = (_asteroidAzimuth - _heading).abs();
    return diff > 180 ? 360 - diff : diff;
  }

  // Calcola quanto siamo vicini a puntare all'asteroide
  double _getPointingAccuracy() {
    final dirDiff = _getDirectionDifference();
    // Normalizza a un valore tra 0 e 100
    return math.max(0, 100 - dirDiff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Compass'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startCompass,
            tooltip: 'Recalibrate',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child:
            !_hasCompass
                ? _buildNoCompassUI()
                : (_isCalibrating ? _buildCalibrationUI() : _buildCompassUI()),
      ),
    );
  }

  Widget _buildNoCompassUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compass_calibration_outlined,
            color: Colors.white,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'Compass sensor not available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Your device does not have a compass sensor or it\'s not accessible.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Calibrating Compass',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Please rotate your device in a figure-8 pattern',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Current heading: ${_heading.toStringAsFixed(1)}°',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassUI() {
    final accuracy = _getPointingAccuracy();
    final Color indicatorColor =
        accuracy > 90
            ? Colors.green
            : (accuracy > 70 ? Colors.yellow : Colors.red);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Compass background
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[900],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

                // Compass rose - rotates with the device
                Transform.rotate(
                  angle: _safeRadians(-_heading),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(painter: CompassRosePainter()),
                  ),
                ),

                const Icon(
                  Icons.navigation,
                  color: Colors.red,
                  size: 40,
                ),

                // Asteroid indicator - fixed relative to the world
                Transform.rotate(
                  angle: _safeRadians(_asteroidAzimuth - _heading),
                  child: Transform.translate(
                    offset: const Offset(0, -120),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indicatorColor,
                        boxShadow: [
                          BoxShadow(
                            color: indicatorColor.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Asteroid info panel
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black.withOpacity(0.8),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.asteroid.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    'Direction',
                    '${_asteroidAzimuth.toStringAsFixed(1)}°',
                    Icons.explore,
                  ),
                  _buildInfoItem(
                    'Heading',
                    '${_heading.toStringAsFixed(1)}°',
                    Icons.navigation,
                  ),
                  _buildInfoItem(
                    'Distance',
                    '${_asteroidDistance.toStringAsFixed(1)} mil km',
                    Icons.social_distance,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: accuracy / 100,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  accuracy > 90
                      ? 'Pointing at asteroid!'
                      : (accuracy > 70
                          ? 'Getting closer...'
                          : 'Keep searching...'),
                  style: TextStyle(
                    color: indicatorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }

  // Funzione di sicurezza per evitare valori NaN
  double _safeRadians(double degrees) {
    if (!degrees.isFinite) return 0.0;
    return radians(degrees);
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

// Painter per la rosa dei venti
class CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Disegna il cerchio esterno
    canvas.drawCircle(center, radius - 10, paint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Disegna le direzioni cardinali
    final directions = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = radians((i * 90).toDouble());
      final offset = Offset(
        center.dx + (radius - 40) * math.sin(angle),
        center.dy - (radius - 40) * math.cos(angle),
      );

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: i == 0 ? Colors.red : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2,
        ),
      );
    }

    // Disegna le direzioni intermedie
    final interDirections = ['NE', 'SE', 'SW', 'NW'];
    for (int i = 0; i < 4; i++) {
      final angle = radians((i * 90 + 45).toDouble());
      final offset = Offset(
        center.dx + (radius - 40) * math.sin(angle),
        center.dy - (radius - 40) * math.cos(angle),
      );

      textPainter.text = TextSpan(
        text: interDirections[i],
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2,
        ),
      );
    }

    // Disegna i tick marks per i gradi
    for (int i = 0; i < 360; i += 15) {
      final angle = radians(i.toDouble());
      final outerRadius =
          i % 90 == 0 ? radius - 15 : (i % 45 == 0 ? radius - 20 : radius - 25);

      final start = Offset(
        center.dx + (radius - 10) * math.sin(angle),
        center.dy - (radius - 10) * math.cos(angle),
      );

      final end = Offset(
        center.dx + outerRadius * math.sin(angle),
        center.dy - outerRadius * math.cos(angle),
      );

      canvas.drawLine(
        start,
        end,
        Paint()
          ..color =
              i % 90 == 0
                  ? Colors.white
                  : (i % 45 == 0 ? Colors.white70 : Colors.white38)
          ..strokeWidth = i % 90 == 0 ? 3 : (i % 45 == 0 ? 2 : 1),
      );

      if (i % 30 == 0 && i % 90 != 0 && i % 45 != 0) {
        final textOffset = Offset(
          center.dx + (radius - 35) * math.sin(angle),
          center.dy - (radius - 35) * math.cos(angle),
        );

        textPainter.text = TextSpan(
          text: '$i°',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            textOffset.dx - textPainter.width / 2,
            textOffset.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CompassRosePainter oldDelegate) => false;
}
