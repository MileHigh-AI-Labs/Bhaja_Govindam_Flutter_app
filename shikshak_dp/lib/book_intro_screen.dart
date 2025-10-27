import 'package:flutter/material.dart';
import 'dart:math' as math;

class BookIntroScreen extends StatefulWidget {
  final VoidCallback onBookOpened;

  const BookIntroScreen({super.key, required this.onBookOpened});

  @override
  State<BookIntroScreen> createState() => _BookIntroScreenState();
}

class _BookIntroScreenState extends State<BookIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _openAnimation;
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _openAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onBookOpened();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openBook() {
    if (!_isOpening) {
      setState(() {
        _isOpening = true;
      });
      _controller.forward();
    }
  }

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
        child: Center(
          child: AnimatedBuilder(
            animation: _openAnimation,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title above book
                  Opacity(
                    opacity: 1 - _openAnimation.value,
                    child: Column(
                      children: [
                        const Text(
                          'Adhi Shankara Charya',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bhaja Govindam',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                  // Book
                  GestureDetector(
                    onTap: _openBook,
                    child: _buildBook(),
                  ),
                  // Tap instruction
                  const SizedBox(height: 50),
                  Opacity(
                    opacity: 1 - _openAnimation.value,
                    child: Column(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white.withOpacity(0.8),
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap on the book to open',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBook() {
    return Transform.scale(
      scale: 1 + (_openAnimation.value * 0.3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Book shadow
          Positioned(
            bottom: -30,
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6 - (_openAnimation.value * 0.5)),
                    spreadRadius: 20,
                    blurRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // Complete book cover
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(-_openAnimation.value * math.pi / 2),
            child: Opacity(
              opacity: 1 - (_openAnimation.value * 1.5).clamp(0.0, 1.0),
              child: Container(
                width: 300,
                height: 440,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1F2937), // Dark gray
                      Color(0xFF111827), // Darker gray
                      Color(0xFF0F172A), // Darkest
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF59E0B), // Amber gold border
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  ),
                child: Stack(
                  children: [
                    // Worn spots overlay
                    Positioned(
                      top: 40,
                      left: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      right: 40,
                      child: Container(
                        width: 60,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Scratches
                    Positioned(
                      top: 120,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      left: 25,
                      right: 30,
                      child: Container(
                        height: 1,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                    // Corner wear
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Logo in circular shape - top left
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFBBF24), // Amber border
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              'assets/sdplogo-removebg-preview.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Logo in circular shape - top right (Mile High AI Labs)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A), // Navy blue background
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFBBF24), // Amber border
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              'assets/Screenshot 2025-07-08 135823.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Cover content
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Om symbol - Large and prominent
                            const Text(
                              'ॐ',
                              style: TextStyle(
                                fontSize: 48,
                                color: Color(0xFFFBBF24), // Bright amber
                                fontWeight: FontWeight.w300,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(2, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Main title
                            const Text(
                              'Bhaja Govindam',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFBBF24), // Bright amber
                                letterSpacing: 1.5,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Adi Shankaracharya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFD1D5DB), // Light gray
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 20),
                              Container(
                              height: 180,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                              color: const Color(0xFFF59E0B), // Amber
                              width: 2.5,
                              ),
                              boxShadow: [
                              BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              ),
                              ],
                              ),
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                              'assets/shankaracharya.png',
                              fit: BoxFit.cover,
                              ),
                              ),
                              ),
                          ],
                        ),
                      ),
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

  Widget _buildOrnament() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD4AF37),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
