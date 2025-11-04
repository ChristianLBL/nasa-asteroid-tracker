import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/asteroid_provider.dart';
import '../widgets/asteroid_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/date_range_picker.dart';
import 'asteroid_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = startDate.add(const Duration(days: 7));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAsteroids();
    });
  }

  void _loadAsteroids() {
    final formatter = DateFormat('yyyy-MM-dd');
    Provider.of<AsteroidProvider>(context, listen: false).fetchFeed(
      startDate: formatter.format(startDate),
      endDate: formatter.format(endDate),
    );
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
              Icons.track_changes,
              color: Colors.cyanAccent,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'ASTEROID FEED',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: Colors.white,
                fontFamily: 'Orbitron', // Usa un font futuristico se disponibile
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.cyanAccent,
              ),
              onPressed: _loadAsteroids,
            ),
          ],
        ),
      ),
    ),
  ),
),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/space_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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

            if (provider.feedAsteroids.isEmpty) {
              return const Center(
                child: Text(
                  'No asteroids found for the selected date range.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Sort dates
            final sortedDates = provider.feedAsteroids.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DateRangePicker(
                    initialStartDate: startDate,
                    initialEndDate: endDate,
                    onDateRangeSelected: (start, end) {
                      setState(() {
                        startDate = DateFormat('yyyy-MM-dd').parse(start);
                        endDate = DateFormat('yyyy-MM-dd').parse(end);
                      });
                      Provider.of<AsteroidProvider>(context, listen: false)
                          .fetchFeed(
                        startDate: start,
                        endDate: end,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final date = sortedDates[index];
                      final asteroids = provider.feedAsteroids[date]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                DateFormat('EEEE, MMMM d, yyyy')
                                    .format(DateTime.parse(date)),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ...asteroids.map((asteroid) => AsteroidCard(
                                asteroid: asteroid,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AsteroidDetailScreen(
                                        asteroid: asteroid,
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ],
                      );
                    },
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

