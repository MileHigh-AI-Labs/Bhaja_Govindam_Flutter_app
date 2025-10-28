import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Introduction',
              'Welcome to Shikshak DP - Bhaja Govindam App. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we handle your information.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Information We Collect',
              'This app does not collect, store, or share any personal information. All data is stored locally on your device including:\n\n• Shloka reading preferences\n• Search history\n• Notification settings\n• Audio sync data',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Data Storage',
              'All app data is stored locally on your device using SharedPreferences. No data is transmitted to external servers except:\n\n• Loading YouTube audio players (YouTube\'s privacy policy applies)\n• Checking for updates from shikshakdp.com',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Third-Party Services',
              'This app uses the following third-party services:\n\n• YouTube Player: For audio playback\n• Google Fonts: For text styling\n\nThese services have their own privacy policies.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Permissions',
              'The app may request the following permissions:\n\n• Internet: To load YouTube audio and check for updates\n• Notifications: To notify you of new content (optional)',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Children\'s Privacy',
              'This app is suitable for all ages and does not knowingly collect information from children.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Changes to Privacy Policy',
              'We may update this privacy policy from time to time. Any changes will be reflected in the app.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Contact Us',
              'If you have questions about this privacy policy, please contact us through:\n\nWebsite: https://www.shikshakdp.com',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Last Updated: ${DateTime.now().year}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
