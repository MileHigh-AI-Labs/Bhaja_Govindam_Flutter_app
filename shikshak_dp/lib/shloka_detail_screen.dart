import 'package:flutter/material.dart';
import 'model/shloka_model.dart'; // Ensure this path is correct

// Enum to manage which content is currently selected
enum ContentType { devanagari, transliteration, wordMeaning, commentary, none }

class ShlokaDetailScreen extends StatefulWidget {
  final Shloka shloka;

  const ShlokaDetailScreen({super.key, required this.shloka});

  @override
  State<ShlokaDetailScreen> createState() => _ShlokaDetailScreenState();
}

class _ShlokaDetailScreenState extends State<ShlokaDetailScreen> {
  ContentType? _flippedCard;

  void _toggleCard(ContentType type) {
    setState(() {
      if (_flippedCard == type) {
        _flippedCard = null; // Flip back
      } else {
        _flippedCard = type; // Flip to show content
      }
    });
  }

  String _formatContent(ContentType type) {
    String textToShow;
    bool shouldFormatWithLineBreaks = false;

    switch (type) {
      case ContentType.devanagari:
        textToShow = widget.shloka.devanagari;
        shouldFormatWithLineBreaks = true;
        break;
      case ContentType.transliteration:
        textToShow = widget.shloka.transliteration;
        shouldFormatWithLineBreaks = true;
        break;
      case ContentType.wordMeaning:
        textToShow = widget.shloka.wordToWordMeaning;
        break;
      case ContentType.commentary:
        textToShow = widget.shloka.commentary;
        break;
      case ContentType.none:
        return '';
    }

    // Format text with line breaks after vertical bars for Devanagari and Transliteration
    if (shouldFormatWithLineBreaks) {
      if (type == ContentType.devanagari) {
        // Devanagari uses । (danda) and ॥ (double danda)
        textToShow = textToShow.replaceAll('।', '\n');
        textToShow = textToShow.replaceAll('॥', '');
      } else if (type == ContentType.transliteration) {
        // Remove the ending verse number pattern like "|| 1 ||" or "|| 33 ||"
        textToShow = textToShow.replaceAllMapped(
          RegExp(r'\|\|\s*\d+\s*\|\|'),
          (match) => '',
        );
        // Transliteration uses | and ||
        textToShow = textToShow.replaceAll(' || ', '\n');
        textToShow = textToShow.replaceAll(' | ', '\n');
        textToShow = textToShow.replaceAll('||', '\n');
        textToShow = textToShow.replaceAll('|', '\n');
      }
      // Trim any extra whitespace
      textToShow = textToShow.trim();
    }

    return textToShow;
  }

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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.shloka.shlokaNo,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Flip Cards
                        _buildFlipCard(
                          'Devanagari',
                          Icons.translate,
                          ContentType.devanagari,
                          [Colors.purple[400]!, Colors.deepPurple[600]!],
                        ),
                        const SizedBox(height: 12),
                        _buildFlipCard(
                          'Transliteration',
                          Icons.text_fields,
                          ContentType.transliteration,
                          [Colors.orange[400]!, Colors.deepOrange[600]!],
                        ),
                        const SizedBox(height: 12),
                        _buildFlipCard(
                          'Word Meaning',
                          Icons.menu_book,
                          ContentType.wordMeaning,
                          [Colors.amber[400]!, Colors.orange[600]!],
                        ),
                        const SizedBox(height: 12),
                        _buildFlipCard(
                          'Commentary',
                          Icons.description,
                          ContentType.commentary,
                          [Colors.purple[600]!, Colors.deepPurple[800]!],
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
    );
  }

  Widget _buildFlipCard(
    String label,
    IconData icon,
    ContentType type,
    List<Color> gradientColors,
  ) {
    final bool isFlipped = _flippedCard == type;
    final bool shouldCenter = type == ContentType.devanagari ||
                             type == ContentType.transliteration;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: isFlipped ? 1 : 0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final angle = value * 3.14159;
        final isUnder = value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(angle),
          child: Container(
            constraints: BoxConstraints(
              minHeight: isFlipped ? 200 : 70,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8DCC4), // Aged palm leaf beige
              borderRadius: BorderRadius.circular(8),
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
                      isFlipped ? 15 : 5,
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
                // Aging spots
                if (!isFlipped) ...[
                  Positioned(
                    top: 8,
                    left: 15,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD4C4A8).withOpacity(0.4),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: Container(
                      width: 30,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFCDB895).withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
                // Main content
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _toggleCard(type),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: isUnder
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateX(3.14159),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(icon, color: const Color(0xFF3E2723), size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              label,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3E2723),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.close,
                                          color: Color(0xFF5D4037),
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _formatContent(type),
                                      style: TextStyle(
                                        fontSize: type == ContentType.devanagari ? 18 : 14,
                                        height: shouldCenter ? 2.0 : 1.6,
                                        color: const Color(0xFF3E2723),
                                      ),
                                      textAlign: shouldCenter ? TextAlign.center : TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon, color: const Color(0xFF3E2723), size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E2723),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF5D4037),
                                  size: 24,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}