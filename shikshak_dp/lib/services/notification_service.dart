import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  // Initialize notification service
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOSSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Load unread count
    await _loadUnreadCount();
  }

  // Check for new content on the website
  Future<void> checkForNewContent() async {
    try {
      final url = Uri.parse('https://www.shikshakdp.com/content/bhaja-govindam/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        // Find article titles or content items
        // This selector might need adjustment based on actual website structure
        final articles = document.querySelectorAll('article, .post, .entry');

        if (articles.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          final seenArticles = prefs.getStringList('seen_articles') ?? [];

          List<String> newArticles = [];

          for (var article in articles) {
            // Get article identifier (title, ID, or URL)
            final titleElement = article.querySelector('h1, h2, h3, .title');
            if (titleElement != null) {
              final title = titleElement.text.trim();
              if (title.isNotEmpty && !seenArticles.contains(title)) {
                newArticles.add(title);
              }
            }
          }

          if (newArticles.isNotEmpty) {
            // Show notification
            await _showNotification(
              'New Bhaja Govindam Content!',
              '${newArticles.length} new ${newArticles.length == 1 ? 'article' : 'articles'} available',
            );

            // Update unread count
            _unreadCount += newArticles.length;
            await _saveUnreadCount();

            // Save new articles as seen
            seenArticles.addAll(newArticles);
            await prefs.setStringList('seen_articles', seenArticles);
          }
        }
      }
    } catch (e) {
      print('Error checking for new content: $e');
    }
  }

  // Show local notification
  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'bhaja_govindam_channel',
      'Bhaja Govindam Updates',
      channelDescription: 'Notifications for new Bhaja Govindam content',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const macOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macOSDetails,
    );

    await _notifications.show(
      0,
      title,
      body,
      details,
    );
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    _unreadCount = 0;
    await _saveUnreadCount();
  }

  // Load unread count from storage
  Future<void> _loadUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _unreadCount = prefs.getInt('unread_count') ?? 0;
  }

  // Save unread count to storage
  Future<void> _saveUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unread_count', _unreadCount);
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    if (await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false) {
      return true;
    }

    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return result ?? false;
  }
}
