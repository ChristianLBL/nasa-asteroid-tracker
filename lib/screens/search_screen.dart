import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/asteroid_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'asteroid_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchAsteroid() {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an asteroid ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _isSearching = true;
    });
    Provider.of<AsteroidProvider>(context, listen: false)
        .fetchAsteroid(id)
        .then((_) {
      setState(() {
        _isSearching = false;
      });
      
      final provider = Provider.of<AsteroidProvider>(context, listen: false);
      if (provider.selectedAsteroid != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AsteroidDetailScreen(
              asteroid: provider.selectedAsteroid!,
            ),
          ),
        ).then((_) {
          provider.clearSelectedAsteroid();
        });
      }
    }).catchError((error) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
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
                    Icons.search,
                    color: Colors.cyanAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SEARCH ASTEROID',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.cyanAccent,
                    ),
                    onPressed: () {
                      // Azione per le opzioni di ricerca avanzate
                    },
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titolo e descrizione con stile futuristico
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.cyanAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'ASTEROID LOOKUP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Search for a specific asteroid using its NASA JPL small body ID (e.g., 3542519)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Campo di ricerca con stile futuristico
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter asteroid ID',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.cyanAccent,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () => _controller.clear(),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _searchAsteroid(),
                  cursorColor: Colors.cyanAccent,
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Pulsante di ricerca con stile futuristico
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSearching ? null : _searchAsteroid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey[800],
                    disabledForegroundColor: Colors.grey[500],
                    elevation: 5,
                    shadowColor: Colors.cyanAccent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'SEARCH',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Esempi di ID con stile futuristico
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Example IDs: 3542519, 3726710, 2000433',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.content_copy,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        _controller.text = '3542519';
                      },
                      tooltip: 'Copy example ID',
                    ),
                  ],
                ),
              ),
              
              // Widget di caricamento o errore
              Consumer<AsteroidProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Expanded(
                      child: LoadingWidget(message: 'Searching asteroid...'),
                    );
                  }
                  if (provider.error != null) {
                    return Expanded(
                      child: ErrorDisplayWidget(
                        error: provider.error!,
                        onRetry: _searchAsteroid,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
