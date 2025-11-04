import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'browse_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const FeedScreen(),
    const BrowseScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: -5,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.cyanAccent.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          items: [
            _buildNavItem(Icons.public, 'FEED', 0),
            _buildNavItem(Icons.explore, 'BROWSE', 1),
            _buildNavItem(Icons.search, 'SEARCH', 2),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Icon(
          icon,
          size: 24,
          color: _currentIndex == index ? Colors.cyanAccent : Colors.grey,
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.cyanAccent,
            ),
            Positioned(
              bottom: -8,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.cyanAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
      label: label,
    );
  }
}
