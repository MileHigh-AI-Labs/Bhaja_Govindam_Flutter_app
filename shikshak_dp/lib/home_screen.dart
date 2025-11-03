import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'spiritual_quotes_screen.dart';
import 'services/notification_service.dart';
import 'services/audio_sync_service.dart';
import 'search_screen.dart';
import 'privacy_policy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  final AudioSyncService _audioSyncService = AudioSyncService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCheckingUpdates = false;

  // Helper method to get time-based greeting
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 5) {
      return 'Good Night';
    } else if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Check for new content and sync audio
  Future<void> _checkForUpdates() async {
    if (_isCheckingUpdates) return;

    setState(() {
      _isCheckingUpdates = true;
    });

    // Check for new content notifications
    await _notificationService.checkForNewContent();

    // Sync audio URLs for shlokas 20-33
    final audioSyncResult = await _audioSyncService.syncAudioUrls();

    setState(() {
      _isCheckingUpdates = false;
    });

    if (mounted) {
      String message = '';

      if (_notificationService.unreadCount > 0) {
        message = '${_notificationService.unreadCount} new updates found!';
      } else {
        message = 'No new updates';
      }

      // Add audio sync info
      if (audioSyncResult['success'] == true && audioSyncResult['count'] > 0) {
        message += '\n${audioSyncResult['count']} new audio links synced!';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Share app
  void _shareApp() {
    Share.share(
      'Check out Shikshak DP - Bhaja Govindam App! '
      'Learn all 33 sacred verses with Devanagari, transliteration, meanings, and commentary. '
      '\n\nDownload: https://www.shikshakdp.com',
      subject: 'Shikshak DP - Bhaja Govindam',
    );
  }

  // Visit website
  Future<void> _visitWebsite() async {
    final url = Uri.parse('https://www.shikshakdp.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open website')),
        );
      }
    }
  }

  // Open social media URL
  Future<void> _openSocialMedia(String urlString, String platform) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $platform')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFFFFA500), // Orange
              Color(0xFFFF8C00), // Dark Orange
              Color(0xFFFF6347), // Tomato/Fire Orange
              Color(0xFFFF4500), // Orange Red
            ],
            stops: [0.0, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Om Symbol Watermark in Center
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'ॐ',
                      style: TextStyle(
                        fontSize: 180,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                    // App Title with Logo
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/sdplogo-removebg-preview.png',
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Shikshak DP',
                              style: GoogleFonts.cinzelDecorative(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                                shadows: [
                                  const Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right Icons
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: _isCheckingUpdates
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Icon(Icons.notifications_outlined,
                                        color: Colors.white, size: 24),
                                onPressed: _checkForUpdates,
                              ),
                            ),
                            if (_notificationService.unreadCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    _notificationService.unreadCount > 9
                                        ? '9+'
                                        : '${_notificationService.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white, size: 24),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Greeting
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Seeker!',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            // Profile Badge with Om Symbol (Clickable) with Quote indicator
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SpiritualQuotesScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 66,
                                    height: 66,
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
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFA7D129), // Light green
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'ॐ',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6B46C1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Quote',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Featured Card
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen = constraints.maxWidth < 360;
                            final imageWidth = isSmallScreen ? 100.0 : 120.0;
                            final imageHeight = isSmallScreen ? 150.0 : 180.0;
                            final cardPadding = isSmallScreen ? 16.0 : 20.0;
                            final titleFontSize = isSmallScreen ? 20.0 : 24.0;
                            final subtitleFontSize = isSmallScreen ? 18.0 : 22.0;

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF0C1E4D), // Very Dark Blue
                                    Color(0xFF1E3A8A), // Blue-900
                                    Color(0xFF1E40AF), // Blue-800
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    // Background Pattern
                                    Positioned.fill(
                                      child: Opacity(
                                        opacity: 0.1,
                                        child: Image.network(
                                          'https://images.unsplash.com/photo-1604608672516-f1b9b1f9b8e9?w=800',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Container(color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: EdgeInsets.all(cardPadding),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Shankaracharya Image on the left
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              'assets/shankaracharya.png',
                                              height: imageHeight,
                                              width: imageWidth,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: isSmallScreen ? 12 : 16),
                                          // Text content on the right
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Main Title
                                                Text(
                                                  'BHAJA GOVINDAM',
                                                  style: TextStyle(
                                                    fontSize: titleFontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'SHLOKAS',
                                                  style: TextStyle(
                                                    fontSize: subtitleFontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                // Subtitle
                                                Text(
                                                  'The Ultimate Verses\nTo Master Life by\nAdi Shankaracharya',
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen ? 12 : 14,
                                                    color: Colors.white,
                                                    height: 1.4,
                                                  ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 20),
                                                // Info Text
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: isSmallScreen ? 8 : 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    'COMPLETE COLLECTION',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 10 : 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '33 Sacred Verses Available Now',
                                                  style: TextStyle(
                                                    fontSize: isSmallScreen ? 11 : 13,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 20),
                                                // Action Button
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const BhajaGovindamHomePage(),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    foregroundColor: const Color(0xFF6B46C1),
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: isSmallScreen ? 16 : 20,
                                                      vertical: 12,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    elevation: 5,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.play_arrow_rounded,
                                                        size: isSmallScreen ? 20 : 24),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        'Start Reading',
                                                        style: TextStyle(
                                                          fontSize: isSmallScreen ? 14 : 16,
                                                          fontWeight: FontWeight.bold,
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Additional Info Cards
                        const Text(
                          'About',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Bhaja Govindam is a popular devotional composition in Sanskrit composed by Adi Shankaracharya. It comprises 33 verses that emphasize the importance of devotion to God and the transient nature of material wealth.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.6,
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
        ),
      ],
    ),
      ),
    );
  }

  // Build drawer menu
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A0B2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Simple drawer header without logo/text
          const SizedBox(height: 60),
          // Privacy Policy
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const Divider(color: Colors.white24),
          // Share the App
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              'Share the App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _shareApp();
            },
          ),
          const Divider(color: Colors.white24),
          // Visit Us
          ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              'Visit Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _visitWebsite();
            },
          ),
          // Social Media Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Facebook
                _buildSocialIcon(
                  color: const Color(0xFF1877F2),
                  icon: Icons.facebook,
                  onTap: () {
                    Navigator.pop(context);
                    _openSocialMedia('https://www.facebook.com/shikshakdp', 'Facebook');
                  },
                ),
                // LinkedIn
                _buildSocialImageIcon(
                  imagePath: 'assets/Linkedin logo.png',
                  onTap: () {
                    Navigator.pop(context);
                    _openSocialMedia('https://www.linkedin.com/company/shikshak-digital-publishing/', 'LinkedIn');
                  },
                ),
                // Instagram
                _buildSocialImageIcon(
                  imagePath: 'assets/instagram logo.png',
                  onTap: () {
                    Navigator.pop(context);
                    _openSocialMedia('https://www.instagram.com/shikshakdp', 'Instagram');
                  },
                ),
                // YouTube
                _buildSocialIcon(
                  color: const Color(0xFFFF0000),
                  icon: Icons.play_arrow,
                  onTap: () {
                    Navigator.pop(context);
                    _openSocialMedia('https://www.youtube.com/@shikshakdp', 'YouTube');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build social media icon button
  Widget _buildSocialIcon({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // Build social media image icon button
  Widget _buildSocialImageIcon({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
