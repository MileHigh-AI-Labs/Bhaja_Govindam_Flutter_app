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
  ContentType _selectedContent = ContentType.none;

  Widget _buildContent() {
    String textToShow;
    switch (_selectedContent) {
      case ContentType.devanagari:
        textToShow = widget.shloka.devanagari;
        break;
      case ContentType.transliteration:
        textToShow = widget.shloka.transliteration;
        break;
      case ContentType.wordMeaning:
        textToShow = widget.shloka.wordToWordMeaning;
        break;
      case ContentType.commentary:
        textToShow = widget.shloka.commentary;
        break;
      case ContentType.none:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(textToShow, style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shloka.solkaNo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _selectedContent = ContentType.devanagari),
                  child: const Text('Devanagari'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _selectedContent = ContentType.transliteration),
                  child: const Text('Transliteration'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _selectedContent = ContentType.wordMeaning),
                  child: const Text('Word Meaning'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _selectedContent = ContentType.commentary),
                  child: const Text('Commentary'),
                ),
              ],
            ),
            const Divider(height: 30),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}