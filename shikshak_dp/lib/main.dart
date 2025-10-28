import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'model/shloka_model.dart'; // Ensure this path is correct
import 'shloka_detail_screen.dart'; // Import the detail screen
import 'home_screen.dart'; // Import the home screen
import 'services/notification_service.dart';
import 'services/audio_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HomeScreen(),
    );
  }
}

class BhajaGovindamHomePage extends StatelessWidget {
  const BhajaGovindamHomePage({super.key});

  // Meaningful labels for each shloka based on their essence
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E), // Deep purple background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bhaja Govindam',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '33 Sacred Verses by Adi Shankaracharya',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: FutureBuilder<List<Shloka>>(
                future: loadShlokas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final shlokas = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0, // Square cards
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: shlokas.length,
                      itemBuilder: (context, index) {
                        return ShlokaGridCard(
                          shloka: shlokas[index],
                          index: index,
                          label: shlokaLabels[index],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('No data found.', style: TextStyle(color: Colors.white)),
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

class ShlokaGridCard extends StatelessWidget {
  final Shloka shloka;
  final int index;
  final String label;

  const ShlokaGridCard({
    super.key,
    required this.shloka,
    required this.index,
    required this.label,
  });

  // 33 Unique gradient colors matching your specifications
  static const List<List<Color>> cardGradients = [
    [Color(0xFFADD8E6), Color(0xFF008B8B)], // 1. Pale Sky Blue → Deep Teal
    [Color(0xFFFFD700), Color(0xFF800020)], // 2. Bright Gold → Rich Maroon
    [Color(0xFFFFB6C1), Color(0xFFFF1493)], // 3. Soft Pink → Bright Magenta
    [Color(0xFFFFE4B5), Color(0xFFFFBF00)], // 4. Light Honey Yellow → Warm Amber
    [Color(0xFFFFFF00), Color(0xFFFF4500)], // 5. Bright Yellow → Fiery Orange
    [Color(0xFFFFFDD0), Color(0xFF8B4513)], // 6. Cream → Earthy Brown
    [Color(0xFF191970), Color(0xFF4169E1)], // 7. Midnight Blue → Royal Purple
    [Color(0xFF8FBC8F), Color(0xFF708090)], // 8. Moss Green → Stone Gray
    [Color(0xFFE6E6FA), Color(0xFF8B008B)], // 9. Pale Lilac → Deep Violet
    [Color(0xFF4B0082), Color(0xFF000000)], // 10. Deep Indigo → Black
    [Color(0xFFC0C0C0), Color(0xFF191970)], // 11. Soft Silver-White → Midnight Blue
    [Color(0xFFFF8C00), Color(0xFF4B0082)], // 12. Warm Orange → Deep Purple-Blue
    [Color(0xFF32CD32), Color(0xFF228B22)], // 13. Lime Green → Emerald Green
    [Color(0xFF8B4513), Color(0xFFFFD700)], // 14. Dark Brown → Glowing Gold
    [Color(0xFFB0C4DE), Color(0xFF2F4F4F)], // 15. Misty Blue-Gray → Deep Pine Green
    [Color(0xFF98FB98), Color(0xFF00008B)], // 16. Seafoam Green → Deep Ocean Blue
    [Color(0xFFFFB6C1), Color(0xFFC71585)], // 17. Pale Pink → Rose Red
    [Color(0xFFD2B48C), Color(0xFF654321)], // 18. Light Tan → Rich Mahogany
    [Color(0xFF00FF00), Color(0xFF8B00FF)], // 19. Electric Green → Vibrant Violet
    [Color(0xFFFFDAB9), Color(0xFFFF7F50)], // 20. Light Peach → Warm Coral
    [Color(0xFFD3D3D3), Color(0xFF36454F)], // 21. Light Gray → Charcoal
    [Color(0xFF00FFFF), Color(0xFF4169E1)], // 22. Cyan → Royal Blue
    [Color(0xFFFF8C00), Color(0xFFE2725B)], // 23. Burnt Orange → Deep Terracotta
    [Color(0xFFFF00FF), Color(0xFFE6E6FA)], // 24. Bright Fuchsia → Soft Lavender
    [Color(0xFFC0C0C0), Color(0xFF778899)], // 25. Light Silver → Pewter Gray
    [Color(0xFF00BFFF), Color(0xFF8A2BE2)], // 26. Electric Blue → Bright Purple
    [Color(0xFF9966CC), Color(0xFFFFC0CB)], // 27. Amethyst Purple → Pale Quartz Pink
    [Color(0xFFFF0000), Color(0xFF2F4F4F)], // 28. Bright Red → Ash Black
    [Color(0xFFFFFFE0), Color(0xFF808000)], // 29. Pale Yellow → Olive Green
    [Color(0xFFF5F5DC), Color(0xFFF4A460)], // 30. Beige → Sandy Brown
    [Color(0xFFFF8C00), Color(0xFFFF1493)], // 31. Sunset Orange → Hot Pink
    [Color(0xFF008080), Color(0xFF006666)], // 32. Bright Teal → Deep Blue-Green
    [Color(0xFFFFFFFF), Color(0xFFB76E79)], // 33. White → Rose Gold
  ];

  // 33 Unique pattern types matching your specifications
  static const List<String> patternTypes = [
    'concentric_ripples', 'sacred_geometry', 'lotus_mandala', 'honeycomb',
    'sunburst', 'fibonacci_spiral', 'zodiac_wheel', 'labyrinth',
    'vesica_piscis', 'starry_galaxy', 'crescent_moon', 'sunset_water',
    'leaf_veins', 'tree_roots', 'mountain_range', 'ocean_wave',
    'cherry_blossoms', 'wood_grain', 'northern_lights', 'glowing_aura',
    'wispy_smoke', 'water_reflection', 'cracked_earth', 'soft_focus',
    'brushed_metal', 'energy_flow', 'crystalline', 'fire_embers',
    'dappled_light', 'sand_dune', 'vibrant_haze', 'peacock_feather', 'liquid_marble'
  ];

  String get pattern => patternTypes[index];

  @override
  Widget build(BuildContext context) {
    final colors = cardGradients[index % cardGradients.length];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShlokaDetailScreen(
              shloka: shloka,
              gradientColors: colors,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: PatternPainter(pattern: pattern),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Shloka ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pattern painter for card backgrounds - 33 unique patterns
class PatternPainter extends CustomPainter {
  final String pattern;

  PatternPainter({required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    switch (pattern) {
      case 'concentric_ripples': // 1. Concentric Ripples
        for (int i = 1; i <= 4; i++) {
          canvas.drawCircle(center, size.width * 0.15 * i, paint);
        }
        break;

      case 'sacred_geometry': // 2. Sacred Geometry
        for (int i = 0; i < 6; i++) {
          final angle = (i * math.pi) / 3;
          final x = center.dx + size.width * 0.3 * math.cos(angle);
          final y = center.dy + size.width * 0.3 * math.sin(angle);
          canvas.drawLine(center, Offset(x, y), paint);
        }
        canvas.drawCircle(center, size.width * 0.3, paint);
        break;

      case 'lotus_mandala': // 3. Lotus Mandala
        for (int i = 0; i < 8; i++) {
          final angle = (i * 2 * math.pi) / 8;
          final path = Path();
          path.moveTo(center.dx, center.dy);
          path.quadraticBezierTo(
            center.dx + 25 * math.cos(angle),
            center.dy + 25 * math.sin(angle),
            center.dx + 15 * math.cos(angle + 0.4),
            center.dy + 15 * math.sin(angle + 0.4),
          );
          canvas.drawPath(path, fillPaint);
        }
        canvas.drawCircle(center, 8, fillPaint);
        break;

      case 'honeycomb': // 4. Honeycomb
        final hexSize = size.width / 6;
        for (double x = -hexSize; x < size.width + hexSize; x += hexSize * 1.5) {
          for (double y = -hexSize; y < size.height + hexSize; y += hexSize * math.sqrt(3)) {
            _drawHexagon(canvas, Offset(x, y), hexSize / 2, paint);
          }
        }
        break;

      case 'sunburst': // 5. Sunburst
        for (int i = 0; i < 12; i++) {
          final angle = (i * 2 * math.pi) / 12;
          final x = center.dx + size.width * 0.5 * math.cos(angle);
          final y = center.dy + size.width * 0.5 * math.sin(angle);
          canvas.drawLine(center, Offset(x, y), paint);
        }
        canvas.drawCircle(center, 10, fillPaint);
        break;

      case 'fibonacci_spiral': // 6. Fibonacci Spiral
        final path = Path();
        path.moveTo(center.dx, center.dy);
        for (double t = 0; t < 8; t += 0.1) {
          final radius = 5 * math.exp(t * 0.2);
          final angle = t;
          final x = center.dx + radius * math.cos(angle);
          final y = center.dy + radius * math.sin(angle);
          path.lineTo(x, y);
        }
        canvas.drawPath(path, paint);
        break;

      case 'zodiac_wheel': // 7. Zodiac Wheel
        canvas.drawCircle(center, size.width * 0.35, paint);
        for (int i = 0; i < 12; i++) {
          final angle = (i * 2 * math.pi) / 12;
          final x1 = center.dx + size.width * 0.3 * math.cos(angle);
          final y1 = center.dy + size.width * 0.3 * math.sin(angle);
          final x2 = center.dx + size.width * 0.4 * math.cos(angle);
          final y2 = center.dy + size.width * 0.4 * math.sin(angle);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        }
        break;

      case 'labyrinth': // 8. Labyrinth
        for (int i = 1; i <= 3; i++) {
          final rect = Rect.fromCenter(center: center, width: size.width * 0.6 * i / 3, height: size.width * 0.6 * i / 3);
          canvas.drawRect(rect, paint);
        }
        break;

      case 'vesica_piscis': // 9. Vesica Piscis
        canvas.drawCircle(Offset(center.dx - 15, center.dy), 30, paint);
        canvas.drawCircle(Offset(center.dx + 15, center.dy), 30, paint);
        break;

      case 'starry_galaxy': // 10. Starry Galaxy
        for (int i = 0; i < 20; i++) {
          final x = (i * 37) % size.width.toInt();
          final y = (i * 51) % size.height.toInt();
          canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 1 + (i % 3).toDouble(), fillPaint);
        }
        break;

      case 'crescent_moon': // 11. Crescent Moon
        canvas.drawCircle(center, 25, fillPaint);
        final crescentPaint = Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(center.dx + 10, center.dy), 25, crescentPaint);
        break;

      case 'sunset_water': // 12. Sunset Over Water
        final horizonY = size.height * 0.5;
        canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), paint);
        canvas.drawCircle(Offset(center.dx, horizonY - 15), 15, fillPaint);
        for (int i = 0; i < 3; i++) {
          canvas.drawLine(
            Offset(center.dx - 20 + i * 20, horizonY + 10),
            Offset(center.dx - 15 + i * 20, horizonY + 25),
            paint,
          );
        }
        break;

      case 'leaf_veins': // 13. Leaf Veins
        final veinPath = Path();
        veinPath.moveTo(center.dx, center.dy - 30);
        veinPath.lineTo(center.dx, center.dy + 30);
        for (int i = -2; i <= 2; i++) {
          veinPath.moveTo(center.dx, center.dy + i * 10);
          veinPath.lineTo(center.dx + 20, center.dy + i * 10 - 5);
          veinPath.moveTo(center.dx, center.dy + i * 10);
          veinPath.lineTo(center.dx - 20, center.dy + i * 10 - 5);
        }
        canvas.drawPath(veinPath, paint);
        break;

      case 'tree_roots': // 14. Tree Roots
        _drawBranch(canvas, center, -math.pi / 2, 30, 3, paint);
        break;

      case 'mountain_range': // 15. Mountain Range
        final mountainPath = Path();
        mountainPath.moveTo(0, size.height);
        mountainPath.lineTo(size.width * 0.2, size.height * 0.4);
        mountainPath.lineTo(size.width * 0.4, size.height * 0.6);
        mountainPath.lineTo(size.width * 0.6, size.height * 0.3);
        mountainPath.lineTo(size.width * 0.8, size.height * 0.5);
        mountainPath.lineTo(size.width, size.height * 0.4);
        mountainPath.lineTo(size.width, size.height);
        canvas.drawPath(mountainPath, fillPaint);
        canvas.drawPath(mountainPath, paint);
        break;

      case 'ocean_wave': // 16. Ocean Wave
        final wavePath = Path();
        wavePath.moveTo(0, size.height * 0.6);
        for (double i = 0; i < size.width; i += 10) {
          wavePath.quadraticBezierTo(
            i + 5, size.height * 0.55,
            i + 10, size.height * 0.6,
          );
        }
        canvas.drawPath(wavePath, paint);
        break;

      case 'cherry_blossoms': // 17. Cherry Blossoms
        for (int i = 0; i < 5; i++) {
          final angle = (i * 2 * math.pi) / 5;
          final x = center.dx + 15 * math.cos(angle);
          final y = center.dy + 15 * math.sin(angle);
          canvas.drawCircle(Offset(x, y), 5, fillPaint);
        }
        canvas.drawCircle(center, 3, fillPaint);
        break;

      case 'wood_grain': // 18. Wood Grain
        for (int i = 0; i < 5; i++) {
          final path = Path();
          final y = size.height * 0.2 + i * 15;
          path.moveTo(0, y);
          for (double x = 0; x < size.width; x += 20) {
            path.quadraticBezierTo(x + 10, y - 2, x + 20, y);
          }
          canvas.drawPath(path, paint);
        }
        break;

      case 'northern_lights': // 19. Northern Lights
        for (int i = 0; i < 3; i++) {
          final path = Path();
          final baseY = size.height * 0.3 + i * 15;
          path.moveTo(0, baseY);
          for (double x = 0; x < size.width; x += 15) {
            path.quadraticBezierTo(
              x + 7.5, baseY - 10,
              x + 15, baseY,
            );
          }
          canvas.drawPath(path, paint);
        }
        break;

      case 'glowing_aura': // 20. Glowing Aura
        for (int i = 1; i <= 3; i++) {
          canvas.drawCircle(center, 15.0 * i, paint);
        }
        canvas.drawCircle(center, 10, fillPaint);
        break;

      case 'wispy_smoke': // 21. Wispy Smoke
        final smokePath = Path();
        smokePath.moveTo(center.dx, size.height);
        smokePath.quadraticBezierTo(
          center.dx - 20, size.height * 0.6,
          center.dx, size.height * 0.3,
        );
        smokePath.quadraticBezierTo(
          center.dx + 20, size.height * 0.15,
          center.dx - 10, 0,
        );
        canvas.drawPath(smokePath, paint);
        break;

      case 'water_reflection': // 22. Water Reflection
        for (int i = 0; i < 4; i++) {
          final y = center.dy + i * 12;
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            paint..strokeWidth = 1,
          );
        }
        break;

      case 'cracked_earth': // 23. Cracked Earth
        final crackPaint = paint..strokeWidth = 1;
        canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), crackPaint);
        canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), crackPaint);
        canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), crackPaint);
        canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), crackPaint);
        break;

      case 'soft_focus': // 24. Soft Focus (Bokeh)
        for (int i = 0; i < 8; i++) {
          final x = (i * 29) % size.width.toInt();
          final y = (i * 41) % size.height.toInt();
          canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 8 + i % 4, fillPaint);
        }
        break;

      case 'brushed_metal': // 25. Brushed Metal
        for (double y = 0; y < size.height; y += 2) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), paint..strokeWidth = 0.5);
        }
        break;

      case 'energy_flow': // 26. Energy Flow
        for (int i = 0; i < 4; i++) {
          final path = Path();
          final y = size.height * 0.25 + i * 15;
          path.moveTo(0, y);
          for (double x = 0; x < size.width; x += 25) {
            path.quadraticBezierTo(x + 12.5, y + 8, x + 25, y);
          }
          canvas.drawPath(path, paint);
        }
        break;

      case 'crystalline': // 27. Crystalline
        final crystalPath = Path();
        crystalPath.moveTo(center.dx, center.dy - 25);
        crystalPath.lineTo(center.dx + 20, center.dy);
        crystalPath.lineTo(center.dx, center.dy + 25);
        crystalPath.lineTo(center.dx - 20, center.dy);
        crystalPath.close();
        canvas.drawPath(crystalPath, fillPaint);
        canvas.drawPath(crystalPath, paint);
        break;

      case 'fire_embers': // 28. Fire Embers
        for (int i = 0; i < 15; i++) {
          final x = (i * 31) % size.width.toInt();
          final y = size.height * 0.3 + (i * 19) % (size.height * 0.6).toInt();
          final radius = 2 + (i % 3).toDouble();
          canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), radius, fillPaint);
        }
        break;

      case 'dappled_light': // 29. Dappled Light
        for (int i = 0; i < 12; i++) {
          final x = (i * 33) % size.width.toInt();
          final y = (i * 47) % size.height.toInt();
          canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 6 + i % 3, fillPaint);
        }
        break;

      case 'sand_dune': // 30. Sand Dune
        final dunePath = Path();
        dunePath.moveTo(0, size.height * 0.7);
        dunePath.quadraticBezierTo(
          size.width * 0.3, size.height * 0.5,
          size.width * 0.6, size.height * 0.6,
        );
        dunePath.quadraticBezierTo(
          size.width * 0.8, size.height * 0.65,
          size.width, size.height * 0.7,
        );
        canvas.drawPath(dunePath, paint);
        break;

      case 'vibrant_haze': // 31. Vibrant Haze
        for (int i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(center.dx + (i - 1) * 20, center.dy),
            25 - i * 5,
            fillPaint,
          );
        }
        break;

      case 'peacock_feather': // 32. Peacock Feather
        canvas.drawCircle(center, 20, fillPaint);
        canvas.drawCircle(center, 20, paint);
        canvas.drawCircle(center, 12, fillPaint);
        canvas.drawCircle(center, 5, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.fill);
        break;

      case 'liquid_marble': // 33. Liquid Marble
        final marblePath = Path();
        marblePath.moveTo(0, center.dy);
        for (double x = 0; x < size.width; x += 20) {
          marblePath.quadraticBezierTo(
            x + 10, center.dy + 15,
            x + 20, center.dy,
          );
        }
        canvas.drawPath(marblePath, paint);

        final marblePath2 = Path();
        marblePath2.moveTo(0, center.dy + 20);
        for (double x = 0; x < size.width; x += 25) {
          marblePath2.quadraticBezierTo(
            x + 12.5, center.dy + 10,
            x + 25, center.dy + 20,
          );
        }
        canvas.drawPath(marblePath2, paint);
        break;
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBranch(Canvas canvas, Offset start, double angle, double length, int depth, Paint paint) {
    if (depth == 0) return;

    final end = Offset(
      start.dx + length * math.cos(angle),
      start.dy + length * math.sin(angle),
    );

    canvas.drawLine(start, end, paint);

    _drawBranch(canvas, end, angle - 0.5, length * 0.7, depth - 1, paint);
    _drawBranch(canvas, end, angle + 0.5, length * 0.7, depth - 1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<List<Shloka>> loadShlokas() async {
  final String jsonString = await rootBundle.loadString('assets/bhaja_govindam.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);

  // Get synced audio URLs
  final audioSyncService = AudioSyncService();
  final syncedAudioUrls = await audioSyncService.getSavedAudioUrls();

  // Parse shlokas and merge with synced audio URLs
  final shlokas = <Shloka>[];
  for (int i = 0; i < jsonList.length; i++) {
    final json = Map<String, dynamic>.from(jsonList[i]);
    final shlokaNumber = i + 1; // Shloka number is 1-based

    // If this shloka (20-33) has a synced audio URL, override it
    if (shlokaNumber >= 20 && shlokaNumber <= 33 && syncedAudioUrls.containsKey(shlokaNumber)) {
      json['Audio URL'] = syncedAudioUrls[shlokaNumber];
    }

    shlokas.add(Shloka.fromJson(json));
  }

  return shlokas;
}