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

  void _onBackToIntro() {
    setState(() {
      _showBookIntro = true;
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
          : BhajaGovindamHomePage(onBackToIntro: _onBackToIntro),
    );
  }
}

class BhajaGovindamHomePage extends StatelessWidget {
  final VoidCallback onBackToIntro;

  const BhajaGovindamHomePage({super.key, required this.onBackToIntro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1), // Indigo-500
              Color(0xFF8B5CF6), // Violet-500
              Color(0xFF7C3AED), // Violet-600
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern AppBar
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: onBackToIntro,
                        tooltip: 'Back',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title section
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ॐ Bhaja Govindam',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Adi Shankaracharya • 33 Sacred Verses',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Shloka List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFBF8), // Warm off-white
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<Shloka>>(
                    future: loadShlokas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6F00)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFE8DCC4), // Aged palm leaf beige
        border: Border.all(
          color: const Color(0xFFD4AF37), // Golden border
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B6F47),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                shloka.shlokaNo,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap to read more',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF5D4037).withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF8B6F47),
                      size: 18,
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

// Enum for corner positions
enum Corner { topLeft, topRight, bottomLeft, bottomRight }

// Temple-style corner ornament painter
class TempleCornerPainter extends CustomPainter {
  final Corner corner;

  TempleCornerPainter({required this.corner});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37) // Golden color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFFF6F00).withOpacity(0.2) // Saffron fill
      ..style = PaintingStyle.fill;

    // Determine positioning based on corner
    bool isTop = corner == Corner.topLeft || corner == Corner.topRight;
    bool isLeft = corner == Corner.topLeft || corner == Corner.bottomLeft;

    double xMultiplier = isLeft ? 1 : -1;
    double yMultiplier = isTop ? 1 : -1;
    double startX = isLeft ? 10 : size.width - 10;
    double startY = isTop ? 10 : size.height - 10;

    // Draw lotus petal-inspired design
    final path = Path();

    // Center petal
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      startX + (15 * xMultiplier),
      startY + (8 * yMultiplier),
      startX + (25 * xMultiplier),
      startY + (15 * yMultiplier),
    );
    path.quadraticBezierTo(
      startX + (15 * xMultiplier),
      startY + (20 * yMultiplier),
      startX,
      startY + (25 * yMultiplier),
    );

    // Side petal
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      startX + (8 * xMultiplier),
      startY + (15 * yMultiplier),
      startX + (15 * xMultiplier),
      startY + (25 * yMultiplier),
    );
    path.quadraticBezierTo(
      startX + (20 * xMultiplier),
      startY + (15 * yMultiplier),
      startX + (25 * xMultiplier),
      startY,
    );

    // Inner decorative circle (om/bindu symbol)
    canvas.drawCircle(
      Offset(startX + (12 * xMultiplier), startY + (12 * yMultiplier)),
      4,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(startX + (12 * xMultiplier), startY + (12 * yMultiplier)),
      4,
      paint,
    );

    // Draw the lotus petals
    canvas.drawPath(path, paint);

    // Additional decorative dots
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(
          startX + ((20 + i * 5) * xMultiplier),
          startY + ((20 + i * 5) * yMultiplier),
        ),
        1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<List<Shloka>> loadShlokas() async {
  final String jsonString = await rootBundle.loadString('assets/bhaja_govindam.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Shloka.fromJson(json)).toList();
}