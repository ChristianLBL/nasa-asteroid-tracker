import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/asteroid_provider.dart';
import '../widgets/asteroid_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'asteroid_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  int _currentPage = 0;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAsteroids();
    });
  }

  void _loadAsteroids() {
    Provider.of<AsteroidProvider>(context, listen: false).fetchBrowseAsteroids();
  }

  void _nextPage(int totalItems) {
    if ((_currentPage + 1) * _itemsPerPage < totalItems) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.explore,
                    color: Colors.cyanAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'BROWSE ASTEROIDS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Consumer<AsteroidProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const LoadingWidget(message: 'Loading asteroids...');
            }

            if (provider.error != null) {
              return ErrorDisplayWidget(
                error: provider.error!,
                onRetry: _loadAsteroids,
              );
            }

            if (provider.browseAsteroids.isEmpty) {
              return const Center(
                child: Text(
                  'No asteroids found.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final asteroids = provider.browseAsteroids;
            final startIndex = _currentPage * _itemsPerPage;
            final endIndex = (_currentPage + 1) * _itemsPerPage;
            final pageAsteroids = asteroids.sublist(
              startIndex,
              endIndex > asteroids.length ? asteroids.length : endIndex,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pageAsteroids.length,
                    itemBuilder: (context, index) {
                      final asteroid = pageAsteroids[index];
                      return AsteroidCard(
                        asteroid: asteroid,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsteroidDetailScreen(asteroid: asteroid),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
                        onPressed: _currentPage > 0 ? _previousPage : null,
                      ),
                      Text(
                        'Page ${_currentPage + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.cyanAccent),
                        onPressed: (_currentPage + 1) * _itemsPerPage < asteroids.length
                            ? () => _nextPage(asteroids.length)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
