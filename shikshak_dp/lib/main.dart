import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'model/shloka_model.dart'; // Ensure this path is correct
import 'shloka_detail_screen.dart'; // Import the detail screen
import 'book_intro_screen.dart'; // Import the book intro screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showBookIntro = true;

  void _onBookOpened() {
    setState(() {
      _showBookIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: _showBookIntro
          ? BookIntroScreen(onBookOpened: _onBookOpened)
          : const BhajaGovindamHomePage(),
    );
  }
}

class BhajaGovindamHomePage extends StatelessWidget {
  const BhajaGovindamHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[700]!,
              Colors.deepPurple[400]!,
              Colors.orange[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bhaja Govindam',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Adi Shankaracharya',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              // Shloka List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<List<Shloka>>(
                    future: loadShlokas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final shlokas = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: shlokas.length,
                          itemBuilder: (context, index) {
                            final shloka = shlokas[index];
                            return ShlokaCard(shloka: shloka, index: index);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No data found.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShlokaCard extends StatelessWidget {
  final Shloka shloka;
  final int index;

  const ShlokaCard({super.key, required this.shloka, required this.index});

  Color _getGradientColor1(int index) {
    final colors = [Colors.purple[400]!, Colors.orange[400]!, Colors.amber[400]!];
    return colors[index % 3];
  }

  Color _getGradientColor2(int index) {
    final colors = [Colors.deepPurple[600]!, Colors.deepOrange[600]!, Colors.orange[600]!];
    return colors[index % 3];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFE8DCC4), // Aged palm leaf beige
        border: Border.all(
          color: const Color(0xFFB8945F),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Horizontal texture lines (palm leaf ribs)
          Positioned.fill(
            child: Column(
              children: List.generate(
                8,
                (i) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFFD4C4A8).withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Aging spots overlay
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4C4A8).withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 30,
            child: Container(
              width: 40,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFCDB895).withOpacity(0.3),
              ),
            ),
          ),
          // Main content
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShlokaDetailScreen(shloka: shloka),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8945F).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF8B6F47),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shloka.shlokaNo,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to read more',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF5D4037).withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF5D4037),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Shloka>> loadShlokas() async {
  final String jsonString = await rootBundle.loadString('assets/bhaja_govindam.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Shloka.fromJson(json)).toList();
}