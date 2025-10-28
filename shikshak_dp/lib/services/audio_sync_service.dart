import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AudioSyncService {
  static final AudioSyncService _instance = AudioSyncService._internal();
  factory AudioSyncService() => _instance;
  AudioSyncService._internal();

  static const String _audioUrlsKey = 'synced_audio_urls';
  static const String _lastSyncKey = 'last_audio_sync';

  // Sync audio URLs from website for shlokas 20-33
  Future<Map<String, dynamic>> syncAudioUrls() async {
    try {
      final url = Uri.parse('https://www.shikshakdp.com/content/bhaja-govindam/');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return {'success': false, 'message': 'Failed to fetch website'};
      }

      final document = html_parser.parse(response.body);
      final Map<int, String> newAudioUrls = {};

      // Find all YouTube embeds and iframes
      final youtubeElements = document.querySelectorAll('iframe[src*="youtube"], a[href*="youtube"], embed[src*="youtube"]');

      for (var element in youtubeElements) {
        String? youtubeUrl;

        // Check different attributes
        youtubeUrl = element.attributes['src'] ?? element.attributes['href'];

        if (youtubeUrl != null && youtubeUrl.contains('youtube')) {
          // Extract video ID from various YouTube URL formats
          final videoId = _extractYoutubeVideoId(youtubeUrl);

          if (videoId != null) {
            // Try to find associated shloka number nearby in the HTML
            final shlokaNumber = _findShlokaNumber(element, document);

            if (shlokaNumber != null && shlokaNumber >= 20 && shlokaNumber <= 33) {
              newAudioUrls[shlokaNumber] = videoId;
            }
          }
        }
      }

      // Also search in text content for YouTube links
      final textContent = document.body?.text ?? '';
      final youtubeRegex = RegExp(r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})');
      final matches = youtubeRegex.allMatches(textContent);

      // Look for patterns like "Shloka 20", "Verse 21", etc.
      for (var match in matches) {
        final videoId = match.group(1);
        if (videoId != null) {
          // Search nearby text for shloka number
          final startPos = match.start > 100 ? match.start - 100 : 0;
          final endPos = match.end + 100 < textContent.length ? match.end + 100 : textContent.length;
          final contextText = textContent.substring(startPos, endPos);

          final shlokaMatch = RegExp(r'(?:Shloka|Verse|Sloka)\s*(\d+)', caseSensitive: false).firstMatch(contextText);
          if (shlokaMatch != null) {
            final shlokaNum = int.tryParse(shlokaMatch.group(1) ?? '');
            if (shlokaNum != null && shlokaNum >= 20 && shlokaNum <= 33) {
              newAudioUrls[shlokaNum] = videoId;
            }
          }
        }
      }

      // Save to local storage
      if (newAudioUrls.isNotEmpty) {
        await _saveAudioUrls(newAudioUrls);
        return {
          'success': true,
          'message': 'Found ${newAudioUrls.length} new audio links',
          'count': newAudioUrls.length,
          'shlokas': newAudioUrls.keys.toList(),
        };
      } else {
        return {
          'success': true,
          'message': 'No new audio links found',
          'count': 0,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error syncing audio: $e',
      };
    }
  }

  // Extract YouTube video ID from various URL formats
  String? _extractYoutubeVideoId(String url) {
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/v/([a-zA-Z0-9_-]{11})'),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }

  // Try to find shloka number near the element
  int? _findShlokaNumber(element, document) {
    // Look in parent elements and siblings for shloka number
    var current = element;
    for (int i = 0; i < 5; i++) {
      final text = current.text;
      final match = RegExp(r'(?:Shloka|Verse|Sloka)\s*(\d+)', caseSensitive: false).firstMatch(text);
      if (match != null) {
        return int.tryParse(match.group(1) ?? '');
      }

      final parent = current.parent;
      if (parent == null) break;
      current = parent;
    }
    return null;
  }

  // Save audio URLs to local storage
  Future<void> _saveAudioUrls(Map<int, String> audioUrls) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing URLs
    final existing = await getSavedAudioUrls();

    // Merge with new URLs
    existing.addAll(audioUrls);

    // Save as JSON
    final jsonString = jsonEncode(
      existing.map((key, value) => MapEntry(key.toString(), value))
    );

    await prefs.setString(_audioUrlsKey, jsonString);
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Get saved audio URLs
  Future<Map<int, String>> getSavedAudioUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_audioUrlsKey);

    if (jsonString == null) return {};

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(int.parse(key), value.toString()));
    } catch (e) {
      return {};
    }
  }

  // Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(_lastSyncKey);

    if (timeString == null) return null;

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // Clear all saved audio URLs
  Future<void> clearSavedAudioUrls() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_audioUrlsKey);
    await prefs.remove(_lastSyncKey);
  }

  // Get audio URL for a specific shloka
  Future<String?> getAudioUrlForShloka(int shlokaNumber) async {
    final audioUrls = await getSavedAudioUrls();
    return audioUrls[shlokaNumber];
  }
}
