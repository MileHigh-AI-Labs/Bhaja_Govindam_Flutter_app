import 'package:flutter/material.dart';
import 'model/shloka_model.dart';
import 'shloka_detail_screen.dart';
import 'main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shloka> _allShlokas = [];
  List<SearchResult> _searchResults = [];
  bool _isLoading = true;

  // Shloka labels from main.dart
  static const List<String> shlokaLabels = [
    'Worship Govinda', 'True Contentment', 'Beyond Attraction', 'Life\'s Fragility',
    'Conditional Love', 'Body & Breath', 'Life\'s Attachments', 'Self Inquiry',
    'Path to Liberation', 'Truth Dissolves', 'Pride\'s Illusion', 'Time Plays',
    'Complete Teaching', 'Holy Company', 'False Renunciation', 'Bundle of Desires',
    'Noose of Desires', 'Knowledge First', 'True Renunciation', 'Brahman Bliss',
    'Power of Devotion', 'Cycle of Birth', 'Liberated Yogi', 'Dream-like World',
    'See the Self', 'Abandon Negativity', 'Four Practices', 'Sin\'s Consequence',
    'Wealth is Trouble', 'Yoga Practices', 'Guru Devotion', 'Origin Story', 'Name Remembrance'
  ];

  // Card gradients from main.dart
  static const List<List<Color>> cardGradients = [
    [Color(0xFFADD8E6), Color(0xFF008B8B)], // 1
    [Color(0xFFFFD700), Color(0xFF800020)], // 2
    [Color(0xFFFFB6C1), Color(0xFFFF1493)], // 3
    [Color(0xFFFFE4B5), Color(0xFFFFBF00)], // 4
    [Color(0xFFFFFF00), Color(0xFFFF4500)], // 5
    [Color(0xFFFFFDD0), Color(0xFF8B4513)], // 6
    [Color(0xFF191970), Color(0xFF4169E1)], // 7
    [Color(0xFF8FBC8F), Color(0xFF708090)], // 8
    [Color(0xFFE6E6FA), Color(0xFF8B008B)], // 9
    [Color(0xFF4B0082), Color(0xFF000000)], // 10
    [Color(0xFFC0C0C0), Color(0xFF191970)], // 11
    [Color(0xFFFF8C00), Color(0xFF4B0082)], // 12
    [Color(0xFF32CD32), Color(0xFF228B22)], // 13
    [Color(0xFF8B4513), Color(0xFFFFD700)], // 14
    [Color(0xFFB0C4DE), Color(0xFF2F4F4F)], // 15
    [Color(0xFF98FB98), Color(0xFF00008B)], // 16
    [Color(0xFFFFB6C1), Color(0xFFC71585)], // 17
    [Color(0xFFD2B48C), Color(0xFF654321)], // 18
    [Color(0xFF00FF00), Color(0xFF8B00FF)], // 19
    [Color(0xFFFFDAB9), Color(0xFFFF7F50)], // 20
    [Color(0xFFD3D3D3), Color(0xFF36454F)], // 21
    [Color(0xFF00FFFF), Color(0xFF4169E1)], // 22
    [Color(0xFFFF8C00), Color(0xFFE2725B)], // 23
    [Color(0xFFFF00FF), Color(0xFFE6E6FA)], // 24
    [Color(0xFFC0C0C0), Color(0xFF778899)], // 25
    [Color(0xFF00BFFF), Color(0xFF8A2BE2)], // 26
    [Color(0xFF9966CC), Color(0xFFFFC0CB)], // 27
    [Color(0xFFFF0000), Color(0xFF2F4F4F)], // 28
    [Color(0xFFFFFFE0), Color(0xFF808000)], // 29
    [Color(0xFFF5F5DC), Color(0xFFF4A460)], // 30
    [Color(0xFFFF8C00), Color(0xFFFF1493)], // 31
    [Color(0xFF008080), Color(0xFF006666)], // 32
    [Color(0xFFFFFFFF), Color(0xFFB76E79)], // 33
  ];

  @override
  void initState() {
    super.initState();
    _loadShlokas();
  }

  Future<void> _loadShlokas() async {
    final shlokas = await loadShlokas();
    setState(() {
      _allShlokas = shlokas;
      _isLoading = false;
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = <SearchResult>[];
    final lowerQuery = query.toLowerCase().trim();

    // Check if query contains "shloka", "sloka", or "verse" followed by a number
    final shlokaNumberPattern = RegExp(r'(?:shloka|sloka|verse)\s*(\d+)', caseSensitive: false);
    final shlokaMatch = shlokaNumberPattern.firstMatch(lowerQuery);

    if (shlokaMatch != null) {
      // User typed "shloka 12" or similar - search by exact number only
      final targetNumber = int.tryParse(shlokaMatch.group(1) ?? '');
      if (targetNumber != null && targetNumber >= 1 && targetNumber <= 33) {
        final index = targetNumber - 1;
        results.add(SearchResult(
          shloka: _allShlokas[index],
          index: index,
          label: shlokaLabels[index],
          matchType: 'Shloka $targetNumber',
        ));
      }
    } else if (RegExp(r'^\d+$').hasMatch(query)) {
      // Query is just a number - match shlokas that start with this number
      final queryNum = int.tryParse(query);

      for (int i = 0; i < _allShlokas.length; i++) {
        final shlokaNumber = i + 1;

        // For single digit, show all that start with it (1 shows 1, 10-19)
        // For double digit, show exact match only
        if (query.length == 1) {
          if (shlokaNumber.toString().startsWith(query)) {
            results.add(SearchResult(
              shloka: _allShlokas[i],
              index: i,
              label: shlokaLabels[i],
              matchType: 'Shloka $shlokaNumber',
            ));
          }
        } else {
          // Exact match for multi-digit numbers
          if (queryNum == shlokaNumber) {
            results.add(SearchResult(
              shloka: _allShlokas[i],
              index: i,
              label: shlokaLabels[i],
              matchType: 'Shloka $shlokaNumber',
            ));
          }
        }
      }
    } else {
      // Text search - search in labels and content
      for (int i = 0; i < _allShlokas.length; i++) {
        final shloka = _allShlokas[i];
        final label = shlokaLabels[i];
        bool matched = false;
        String matchType = '';

        // Check if query matches label
        if (label.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchType = 'Label Match';
        }
        // Check if query matches in shloka content
        else if (shloka.devanagari.toLowerCase().contains(lowerQuery) ||
            shloka.transliteration.toLowerCase().contains(lowerQuery)) {
          matched = true;
          matchType = 'Content Match';
        }

        if (matched) {
          results.add(SearchResult(
            shloka: shloka,
            index: i,
            label: label,
            matchType: matchType,
          ));
        }
      }
    }

    setState(() {
      _searchResults = results;
    });
  }

  void _navigateToShloka(SearchResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShlokaDetailScreen(
          shloka: result.shloka,
          gradientColors: cardGradients[result.index % cardGradients.length],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search by number or name...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _performSearch('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onChanged: _performSearch,
                        onSubmitted: (value) {
                          if (_searchResults.isNotEmpty) {
                            _navigateToShloka(_searchResults.first);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Results
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : _searchResults.isEmpty && _searchController.text.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No results found',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Try searching by shloka number (1-33)\nor shloka name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Search Bhaja Govindam',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Enter shloka number (1-33) or name',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                final shlokaNum = result.index + 1;
                                final colors = cardGradients[result.index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: colors,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors[0].withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _navigateToShloka(result),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            // Shloka number badge
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.3),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$shlokaNum',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Shloka info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result.label,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Shloka $shlokaNum • ${result.matchType}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white.withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white.withOpacity(0.7),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult {
  final Shloka shloka;
  final int index;
  final String label;
  final String matchType;

  SearchResult({
    required this.shloka,
    required this.index,
    required this.label,
    required this.matchType,
  });
}
