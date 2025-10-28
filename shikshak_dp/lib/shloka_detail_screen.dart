import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'model/shloka_model.dart'; // Ensure this path is correct

// Enum to manage which content is currently selected
enum ContentType { devanagari, transliteration, wordMeaning, commentary, none }

class ShlokaDetailScreen extends StatefulWidget {
  final Shloka shloka;
  final List<Color> gradientColors;

  const ShlokaDetailScreen({
    super.key,
    required this.shloka,
    required this.gradientColors,
  });

  @override
  State<ShlokaDetailScreen> createState() => _ShlokaDetailScreenState();
}

class _ShlokaDetailScreenState extends State<ShlokaDetailScreen> {
  ContentType? _flippedCard;
  YoutubePlayerController? _youtubeController;
  bool _showPlayer = false;

  @override
  void initState() {
    super.initState();
    if (widget.shloka.audioUrl != null && widget.shloka.audioUrl!.isNotEmpty) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: widget.shloka.audioUrl!,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          loop: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  void _togglePlayer() {
    setState(() {
      _showPlayer = !_showPlayer;
    });
  }

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
            colors: widget.gradientColors,
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
                    color: Color(0xFFFCFBF8), // Warm off-white
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Listen on YouTube Button
                        if (widget.shloka.audioUrl != null && widget.shloka.audioUrl!.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    color: Color(0xFF6366F1),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Listen to this Shloka',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0C1E4D),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (_showPlayer)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      color: const Color(0xFF0C1E4D),
                                      onPressed: _togglePlayer,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (_showPlayer && _youtubeController != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    height: 220,
                                    child: YoutubePlayer(
                                      controller: _youtubeController!,
                                      aspectRatio: 16 / 9,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (!_showPlayer)
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _togglePlayer,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF6366F1).withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.play_circle_filled,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Play Audio',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
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
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0C1E4D), // Very Dark Blue
                  Color(0xFF1E3A8A), // Blue-900
                  Color(0xFF1E40AF), // Blue-800
                ],
              ),
              border: Border.all(
                color: const Color(0xFF0A1128),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
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
                                        Icon(icon, color: Colors.white, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.close,
                                      color: Colors.white70,
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
                                    color: Colors.white,
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
                            Icon(icon, color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white70,
                              size: 24,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}