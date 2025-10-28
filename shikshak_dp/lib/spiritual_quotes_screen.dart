import 'package:flutter/material.dart';
import 'dart:math';
import 'package:share_plus/share_plus.dart';

class SpiritualQuotesScreen extends StatelessWidget {
  const SpiritualQuotesScreen({super.key});

  // List of spiritual quotes with authors
  static const List<Map<String, String>> _quotes = [
    {
      'quote': 'The mind is everything. What you think you become.',
      'author': 'Buddha'
    },
    {
      'quote': 'You are not a drop in the ocean. You are the entire ocean in a drop.',
      'author': 'Rumi'
    },
    {
      'quote': 'The soul is neither born, and nor does it die.',
      'author': 'Bhagavad Gita'
    },
    {
      'quote': 'When you make the two one, and when you make the inside like the outside and the outside like the inside, then you will enter the kingdom.',
      'author': 'Gospel of Thomas'
    },
    {
      'quote': 'The only way to do great work is to love what you do.',
      'author': 'Swami Vivekananda'
    },
    {
      'quote': 'In the midst of movement and chaos, keep stillness inside of you.',
      'author': 'Deepak Chopra'
    },
    {
      'quote': 'The greatest religion is to be true to your own nature. Have faith in yourselves.',
      'author': 'Swami Vivekananda'
    },
    {
      'quote': 'Your task is not to seek for love, but merely to seek and find all the barriers within yourself that you have built against it.',
      'author': 'Rumi'
    },
    {
      'quote': 'The self is the friend of a man who masters himself through the self. But for a man without self-mastery, the self is like an enemy at war.',
      'author': 'Bhagavad Gita'
    },
    {
      'quote': 'Truth is one, paths are many.',
      'author': 'Rig Veda'
    },
    {
      'quote': 'The whole world is one family.',
      'author': 'Maha Upanishad (Vasudhaiva Kutumbakam)'
    },
    {
      'quote': 'What we think, we become.',
      'author': 'Upanishads'
    },
    {
      'quote': 'Where there is dharma there is victory.',
      'author': 'Mahabharata'
    },
    {
      'quote': 'The greatest glory in living lies not in never falling, but in rising every time we fall.',
      'author': 'Bhagavad Gita'
    },
    {
      'quote': 'Arise, awake, and stop not until the goal is reached.',
      'author': 'Swami Vivekananda'
    },
    {
      'quote': 'Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.',
      'author': 'Buddha'
    },
    {
      'quote': 'You have the right to work, but never to the fruit of work.',
      'author': 'Bhagavad Gita'
    },
    {
      'quote': 'The energy of the mind is the essence of life.',
      'author': 'Aristotle'
    },
    {
      'quote': 'Truth alone triumphs.',
      'author': 'Mundaka Upanishad (Satyameva Jayate)'
    },
    {
      'quote': 'Let noble thoughts come to us from all sides.',
      'author': 'Rig Veda'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Pick a random quote each time the screen is opened
    final randomIndex = Random().nextInt(_quotes.length);
    final currentQuote = _quotes[randomIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Background Om image - full opacity
          Positioned.fill(
            child: Image.asset(
              'assets/Om_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
            // Content
            SafeArea(
              child: Column(
                children: [
              // Close button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'ॐ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B46C1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Daily Wisdom',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Quote content
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Opening quote mark
                          const Icon(
                            Icons.format_quote,
                            size: 80,
                            color: Colors.white38,
                          ),
                          const SizedBox(height: 40),
                          // Quote text with beautiful styling
                          Text(
                            '"${currentQuote['quote']!}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.8,
                              letterSpacing: 0.8,
                              fontFamily: 'serif',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 50),
                          // Divider line
                          Container(
                            width: 60,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Author
                          Text(
                            '— ${currentQuote['author']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 80),
                          // Closing quote mark
                          Transform.rotate(
                            angle: pi,
                            child: const Icon(
                              Icons.format_quote,
                              size: 80,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom section with logo and share button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mile High Labs logo on the left
                      Image.asset(
                        'assets/Mile high labs logo.png',
                        height: 50,
                        width: 50,
                      ),
                      // Share button on the right
                      GestureDetector(
                        onTap: () {
                          final quoteText = '"${currentQuote['quote']!}"\n\n— ${currentQuote['author']}\n\nShared from Shikshak DP - Bhaja Govindam App';
                          Share.share(quoteText, subject: 'Daily Wisdom');
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0C1E4D), // Very Dark Blue
                                Color(0xFF1E3A8A), // Blue-900
                                Color(0xFF1E40AF), // Blue-800
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
