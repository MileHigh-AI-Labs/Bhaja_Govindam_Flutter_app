# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Shikshak DP (Bhaja Govindam App)** - A Flutter mobile application presenting all 33 shlokas (verses) from "Bhaja Govindam," a famous Sanskrit devotional composition by Adi Shankaracharya. The app provides an interactive display of each shloka with Devanagari script, English transliteration, word-by-word meanings, and philosophical commentary.

## Architecture

### Application Flow
1. **Home Screen** (`lib/home_screen.dart` - `HomeScreen`):
   - Entry point with radial gradient background (gold to orange-red tones)
   - Features large Om symbol watermark in center
   - Displays featured card with "BHAJA GOVINDAM SHLOKAS" title and "Start Reading" button
   - Includes informational "About" section describing Bhaja Govindam
   - **Top bar**: Menu (opens drawer), notifications (shows update count), search (navigates to search screen)
   - Profile badge showing time-based greeting ("Good Morning", "Good Afternoon", etc.)
   - **Drawer menu** with navigation to: Spiritual Quotes, Privacy Policy, social media links (LinkedIn, Instagram), website, share app
   - **Social features**: Share app functionality, website launch (https://www.shikshakdp.com)
   - Navigation via button press to main shloka list screen

2. **Shloka List Screen** (`lib/main.dart` - `BhajaGovindamHomePage`):
   - Displays all 33 shlokas in a 3×3 grid layout using `GridView.builder`
   - Uses `FutureBuilder` to handle async JSON loading from assets
   - Each card has a **unique gradient** (33 distinct color combinations) defined in `ShlokaGridCard.cardGradients`
   - Each card has a **unique decorative pattern** (33 pattern types) painted via `CustomPaint` and `PatternPainter`
   - Pattern types include: concentric ripples, sacred geometry, lotus mandala, honeycomb, sunburst, Fibonacci spiral, and 27 more unique designs
   - Cards show meaningful labels (e.g., "Worship Govinda", "True Contentment") and shloka number
   - Navigation via `Navigator.push()` to detail screen on card tap
   - Back button returns to home screen
   - Background: Deep purple (#1A0B2E) with header showing "33 Sacred Verses by Adi Shankaracharya"

3. **Detail Screen** (`lib/shloka_detail_screen.dart`):
   - Four interactive flip cards showing different content types
   - 3D flip animation (600ms) when card is tapped using `TweenAnimationBuilder`
   - Content types: Devanagari, Transliteration, Word Meaning, Commentary
   - Special formatting: Devanagari/Transliteration centered with line breaks at verse markers
   - **Embedded YouTube player** (if `audioUrl` is present) - toggle "Play Audio" button reveals/hides iframe player within the app
   - Card styling: Deep blue gradient (#0C1E4D → #1E3A8A → #1E40AF) with white text
   - Background: Gold to fire orange gradient (#FFD700 → #FFA500 → #FF6347)
   - Back button returns to shloka list

4. **Search Screen** (`lib/search_screen.dart`):
   - Full-text search across all shloka content (Devanagari, transliteration, word meanings, commentary)
   - Real-time search as user types
   - Search results show shloka number, label, and matched content snippets
   - Highlights matching text within results
   - Navigation to detail screen from search results
   - Uses same gradient colors as main shloka cards for visual consistency

5. **Spiritual Quotes Screen** (`lib/spiritual_quotes_screen.dart`):
   - Collection of spiritual quotes from various traditions (Buddha, Rumi, Bhagavad Gita, etc.)
   - Random card-based layout with unique colors for each quote card
   - Share functionality for individual quotes
   - Animated card appearance with staggered delays
   - Back button returns to home screen

6. **Privacy Policy Screen** (`lib/privacy_policy_screen.dart`):
   - Displays app privacy policy and data handling information
   - Scrollable content with formatted sections
   - Standard policy screen accessible from drawer menu

### State Management Pattern
- **Root App** (`MyApp` - StatelessWidget): Simple app entry point with theme configuration
- **Local State**: Uses `StatefulWidget` with `setState()` for screen-level state in detail screen
- **No external state management**: No Provider, BLoC, Riverpod, GetX, etc.
- **Animations**: `TweenAnimationBuilder` for flip card animations in detail screen

### Data Layer
- **Model**: `lib/model/shloka_model.dart` - Simple data class with `fromJson()` factory
  - Required fields: `shlokaNo`, `devanagari`, `transliteration`, `wordToWordMeaning`, `commentary`
  - Optional field: `audioUrl` (YouTube video ID for audio playback)
- **Data Source**: JSON asset loaded via `rootBundle.loadString()`
- **Parsing**: Direct JSON deserialization using `Shloka.fromJson()`
- **Persistence**: Uses `shared_preferences` for storing notification read status and synced audio URLs
- **Meaningful Labels**: Each shloka has a meaningful label (e.g., "Worship Govinda", "True Contentment") defined in `BhajaGovindamHomePage.shlokaLabels` array (main.dart:40-48) that summarizes the essence of that verse

### Services Layer
- **NotificationService** (`lib/services/notification_service.dart`):
  - Singleton service managing local notifications using `flutter_local_notifications`
  - Checks for new content by scraping website (https://www.shikshakdp.com/content/bhaja-govindam/)
  - Tracks unread notification count using `shared_preferences`
  - Initialized in `main()` before app launch
  - Platform support: Android and iOS notifications

- **AudioSyncService** (`lib/services/audio_sync_service.dart`):
  - Singleton service for syncing YouTube audio URLs from website
  - Scrapes website HTML using `html` parser to find YouTube embeds for shlokas 20-33
  - Extracts video IDs from various YouTube URL formats
  - Stores synced audio URLs in `shared_preferences`
  - Provides fallback audio for shlokas missing local audio data
  - Called from home screen when user checks for updates

### UI/UX Design System

**Theme Configuration** (in `MyApp`):
```
Primary: deepPurple
Scaffold Background: grey[50]
Global Gradient: Indigo-500 (#6366F1) → Violet-500 (#8B5CF6) → Violet-600 (#7C3AED)
```

**Home Screen Styling**:
- Background: Radial gradient from gold (#FFD700) through orange shades to orange-red (#FF4500)
- Om watermark: Large white Om symbol (180pt) with circular border, 20% opacity
- Featured card: Deep blue gradient (#0C1E4D → #1E3A8A → #1E40AF) with white text
- Top bar icons: White icons on semi-transparent white background (20% opacity)

**Shloka List Screen Styling**:
- Background: Deep purple (#1A0B2E)
- Grid layout: 3 columns with equal spacing (12px)
- Card gradients: 33 unique gradients (see `ShlokaGridCard.cardGradients` array in main.dart:152-186)
- Card patterns: 33 unique patterns painted via `CustomPaint` with `PatternPainter` (main.dart:287-683)
- Card text: White with shadows for readability
- Card dimensions: Square aspect ratio (1.0) with rounded corners (20px radius)

**Detail Screen Styling**:
- Background: Gold to fire orange gradient (#FFD700 → #FFA500 → #FF6347)
- Content area: Warm off-white (#FCFBF8) with rounded top corners (32px radius)
- Flip cards: Deep blue gradient (#0C1E4D → #1E3A8A → #1E40AF) with dark blue border (#0A1128)
- Card text: White with good contrast
- YouTube button: Purple/violet gradient (#6366F1 → #8B5CF6)

**Typography**:
- Title (Bhaja Govindam): 32pt, bold, white, letter-spacing 1.2
- Author: 16pt, italic, white (90% opacity)
- Shloka numbers: 20pt, bold, white
- Devanagari content: 18pt, 2.0 line height, centered
- Other content: 14pt, 1.6 line height, left-aligned

**Animations**:
- Card flips: 600ms with `Curves.easeInOut`
- 3D transformations using `Matrix4.rotateX()` with perspective via `setEntry(3, 2, 0.001)`

## Initialization Requirements

The app requires specific initialization steps in `main()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service BEFORE runApp()
  await NotificationService().initialize();

  runApp(const MyApp());
}
```

**Critical Notes**:
- `WidgetsFlutterBinding.ensureInitialized()` is required for async operations in `main()`
- NotificationService must be initialized before app launch to register notification channels
- Failure to initialize notifications will cause crashes on first notification attempt

## Common Development Commands

```bash
# Setup
flutter pub get                          # Install dependencies

# Running
flutter run                              # Run on connected device/emulator
flutter run -d chrome                    # Run in Chrome browser
flutter run -d windows                   # Run as Windows desktop app
flutter devices                          # List available devices

# Building
flutter build apk                        # Build Android APK (release)
flutter build appbundle                  # Build Android App Bundle
flutter build ios                        # Build iOS (requires macOS)
flutter build windows                    # Build Windows desktop app
flutter build web                        # Build web app

# Testing & Analysis
flutter test                             # Run all tests
flutter test test/widget_test.dart       # Run specific test file
flutter analyze                          # Run static analysis
dart format lib test                     # Format code

# Maintenance
flutter clean                            # Remove build artifacts
flutter doctor                           # Verify Flutter installation
```

## Project Structure

```
lib/
├── main.dart                       # App entry, shloka list screen with custom patterns
├── home_screen.dart                # Landing screen with drawer, notifications, search
├── shloka_detail_screen.dart       # Detail view with flip cards and YouTube player
├── search_screen.dart              # Full-text search across all shlokas
├── spiritual_quotes_screen.dart    # Spiritual quotes collection
├── privacy_policy_screen.dart      # Privacy policy information
├── model/
│   └── shloka_model.dart          # Data model with JSON parsing
└── services/
    ├── notification_service.dart   # Local notifications and content updates
    └── audio_sync_service.dart     # YouTube audio URL syncing from website

assets/
├── bhaja_govindam.json             # 33 shlokas data with audio URLs
├── shankaracharya.png              # Historical image asset
├── sdplogo-removebg-preview.png    # App logo
├── Om_background.png               # Om symbol background
├── Linkedin logo.png               # LinkedIn social media icon
├── instagram logo.png              # Instagram social media icon
└── Mile high labs logo.png         # Developer company logo

test/
└── widget_test.dart                # Widget tests (needs updating)
```

## Data Format & Critical Constraints

The `assets/bhaja_govindam.json` file contains exactly 33 objects with this structure:

```json
{
  "Shloka no.": "Shloka 1",
  "Devanagari": "भज गोविन्दं भज गोविन्दं...",
  " Transliteration": "bhaja govindaṃ bhaja govindaṃ...",
  "Word-to-Word Meaning": "भज (bhaja) – worship...",
  "Commentary": "This verse presents...",
  "Audio URL": "rEWdZNM1vIU"
}
```

**CRITICAL PARSING DETAIL**:
- The `" Transliteration"` key has a **leading space** - this is intentional and handled in `shloka_model.dart:24`
- If you edit the JSON, preserve this space or the app will crash with a null parsing error
- The first five fields are required for each shloka
- `"Audio URL"` is optional and contains a YouTube video ID for audio playback integration

**Text Formatting Logic**:
- **Devanagari**: Line breaks at `।` (danda), removes `॥` (double danda)
- **Transliteration**: Line breaks at `|` and `||`, removes verse numbers like `|| 1 ||`
- **Word Meaning & Commentary**: No special formatting, displayed as-is

## Dependencies

**Production**:
- `flutter` (SDK)
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `url_launcher: ^6.3.1` - Launch URLs (website, social media)
- `youtube_player_iframe: ^5.2.0` - Cross-platform YouTube iframe player
- `google_fonts: ^6.1.0` - Custom fonts for enhanced typography
- `http: ^1.2.0` - HTTP requests for website scraping
- `flutter_local_notifications: ^18.0.1` - Local push notifications (Android/iOS)
- `shared_preferences: ^2.3.3` - Persistent key-value storage
- `html: ^0.15.4` - HTML parsing for web scraping
- `share_plus: ^10.1.2` - Native share functionality

**Dev**:
- `flutter_test` (SDK)
- `flutter_lints: ^5.0.0` - Recommended linting rules

**SDK Requirements**: Dart ^3.9.2

## Animation Implementation Details

### Flip Card Animation
- **Builder**: `TweenAnimationBuilder<double>` with 600ms duration
- **Transform**: `Matrix4.rotateX()` from 0 to π radians
- **Front Face**: Shows icon + label with centered layout
- **Back Face**: Shows full content with scrollable text (uses `Transform.rotateX(π)` to flip content)
- **State Toggle**: Tapping a flipped card closes it, tapping a new card opens it

### YouTube Audio Integration
- **Feature**: Embedded YouTube player on detail screen (appears when `audioUrl` field is present)
- **Implementation**: Uses `youtube_player_iframe` package with `YoutubePlayerController`
- **Platform Support**: Works on all platforms (Android, iOS, Web, Windows, macOS)
- **iOS Configuration Required**:
  - `io.flutter.embedded_views_preview` must be set to `true` in `ios/Runner/Info.plist`
  - `NSAppTransportSecurity` settings configured for web content
  - See Info.plist for complete configuration
- **Behavior**:
  - Shows "Play Audio" button when player is hidden
  - Clicking button toggles embedded YouTube iframe player within the app
  - Player stays within the app (no external redirect for embedded player)
  - Close button (X icon) appears when player is visible to hide it
  - Auto-play disabled by default (user must click play in the player)
  - **Fallback Option**: "Open in YouTube App" button provided for users who prefer external app
  - **Error Handling**: If embedded player fails, shows error message with external link option
- **Video ID**: Uses `audioUrl` field from JSON (e.g., "PWa7Fv4nX6A")
- **Player Configuration**:
  - Fixed height: 220px with 16:9 aspect ratio
  - Controls enabled (play, pause, volume, progress bar)
  - Fullscreen button enabled
  - JavaScript enabled for iOS compatibility
  - Loop disabled, mute disabled
- **Location**: Button and player appear at the top of content area before flip cards

### Custom Pattern Painting System
- **PatternPainter class** (main.dart:287-683): Custom `CustomPainter` that draws 33 unique decorative patterns
- Each shloka card gets a unique pattern based on its index
- Patterns are drawn using Canvas API with paths, circles, lines, and bezier curves
- Pattern examples: concentric ripples, sacred geometry, lotus mandala, honeycomb, sunburst, Fibonacci spiral, zodiac wheel, labyrinth, starry galaxy, cherry blossoms, northern lights, peacock feather, etc.
- All patterns use semi-transparent white colors (15% opacity for strokes, 8% for fills) to overlay on gradient backgrounds
- Helper methods: `_drawHexagon()` for honeycomb pattern, `_drawBranch()` for recursive tree roots pattern

### Shadow & Depth Effects
- Cards have shadow effects with opacity adjustments
- `setEntry(3, 2, 0.001)` adds perspective to 3D flip card transforms

## Adding New Features

### Adding a New Content Type to Shlokas
1. Add new field to `Shloka` class in `lib/model/shloka_model.dart`
2. Update `fromJson()` factory to parse the field
3. Add field to all 33 entries in `assets/bhaja_govindam.json`
4. Add new enum value to `ContentType` in `shloka_detail_screen.dart`
5. Add case to `_formatContent()` switch statement
6. Add new flip card by calling `_buildFlipCard()` in the detail screen `Column`

### Adding Search Functionality
- Search is implemented in `SearchScreen` with real-time filtering
- Searches across all fields: Devanagari, transliteration, word meanings, commentary
- Results include context snippets showing where the match was found
- To add new searchable fields: update `_performSearch()` method in `search_screen.dart`

### Working with Notifications
- Notifications require initialization in `main()` before `runApp()`
- Platform-specific setup may be required (AndroidManifest.xml for Android, Info.plist for iOS)
- Check notification permissions on first launch
- NotificationService maintains singleton pattern - access via `NotificationService()`

### Modifying Animations
- Flip card duration: `duration` in `TweenAnimationBuilder` in `shloka_detail_screen.dart`
- Animation curves: Modify `Curves` parameter in `TweenAnimationBuilder`

### Changing Colors/Theme
- App-wide theme: `MaterialApp` theme in `main.dart:20-23`
- Home screen gradient: Radial gradient in `HomeScreen` build method (home_screen.dart:11-24)
- Shloka list background: Deep purple in `BhajaGovindamHomePage` build method (main.dart:47)
- Shloka card gradients: 33 unique gradients in `ShlokaGridCard.cardGradients` array (main.dart:152-186)
- Detail screen background: Gold-orange gradient in `ShlokaDetailScreen` build method (shloka_detail_screen.dart:113-122)
- Flip card colors: Deep blue gradient in `_buildFlipCard()` method (shloka_detail_screen.dart:333-340)

## Platform Support

Configured for:
- Android (Application ID: `com.example.shikshak_dp`)
- iOS
- Web
- Windows
- macOS
- Linux

### iOS-Specific Configuration

For YouTube player and web content to work on iOS, the following must be configured in `ios/Runner/Info.plist`:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

**Why This Is Needed**:
- `io.flutter.embedded_views_preview`: Enables platform views (required for WebView/YouTube player)
- `NSAppTransportSecurity`: Allows HTTPS connections to YouTube and external images
- Without these settings, YouTube player will not display on iOS devices

### Responsive Design

The app uses `LayoutBuilder` for responsive layouts that adapt to different screen sizes:
- **Small screens** (<360px width): Reduced font sizes, smaller images, compact padding
- **Regular screens** (≥360px width): Normal sizing and spacing
- All text elements use `maxLines` and `TextOverflow.ellipsis` to prevent overflow
- Featured card on home screen dynamically adjusts image size, fonts, and padding based on available width

## Known Issues & Quirks

1. **JSON Leading Space**: The `" Transliteration"` key has a leading space - intentional but unusual
2. **Default Test**: `test/widget_test.dart` still contains counter app template - needs replacement
3. **No Error Handling**: JSON parsing assumes perfect data - malformed JSON will crash the app
4. **Network Dependency**: App checks website for updates but doesn't gracefully handle network failures
5. **Web Scraping Fragility**: AudioSyncService and NotificationService rely on website HTML structure - changes to website may break scraping
6. **Hardcoded URLs**: Social media URLs and website links are hardcoded in `home_screen.dart`
7. **Limited Audio Coverage**: Audio URLs primarily for shlokas 1-19 in JSON, shlokas 20-33 rely on web scraping
8. **No Caching Strategy**: Web scraping results stored in shared_preferences but no TTL or invalidation logic

## Troubleshooting

### YouTube Player Not Working on iOS
If the YouTube player doesn't load on iOS:
1. Verify `ios/Runner/Info.plist` has the required keys (see iOS-Specific Configuration above)
2. Clean and rebuild the iOS app: `flutter clean && flutter pub get && flutter run`
3. Use the "Open in YouTube App" fallback button that appears below the player
4. Check iOS device is running iOS 11 or later (required for WKWebView)

### Layout Overflow Errors
All overflow errors have been fixed with:
- Responsive `LayoutBuilder` in featured card
- `Flexible` widgets wrapping text elements
- Dynamic font sizes based on screen width
- `maxLines` and `TextOverflow.ellipsis` on all text

If you encounter new overflow errors:
- Check the screen width with `MediaQuery.of(context).size.width`
- Wrap fixed-width elements in `Flexible` or `Expanded`
- Use `LayoutBuilder` for responsive sizing

## Testing Strategy

Current test coverage is minimal. Recommended tests:

**Unit Tests**:
- `Shloka.fromJson()` parsing (including space handling)
- `loadShlokas()` async loading
- Content formatting logic in `_formatContent()`
- Search algorithm in `_performSearch()`
- YouTube video ID extraction in AudioSyncService
- Notification count tracking in NotificationService

**Widget Tests**:
- Home screen rendering and navigation
- Shloka list rendering with correct count (33 cards)
- Navigation between screens (home → list → detail → search)
- Flip card state management
- YouTube player toggle functionality
- Search results display and filtering
- Drawer menu items and navigation
- Share functionality trigger

**Integration Tests**:
- End-to-end flow: home → list → detail → back navigation
- Multiple card flips in detail screen
- JSON loading error handling
- Web scraping fallback when network unavailable
- Notification badge updates after checking for content
- Search → detail screen → back to search preserving state

## External Integrations

**Website Integration**:
- Main website: https://www.shikshakdp.com
- Content source: https://www.shikshakdp.com/content/bhaja-govindam/
- Website is scraped for new content notifications and audio URL sync
- HTML structure dependency: Looks for YouTube iframes, embeds, and links

**Social Media Links** (in drawer):
- LinkedIn: Hardcoded company profile URL
- Instagram: Hardcoded company profile URL

**YouTube Integration**:
- Embedded player uses `youtube_player_iframe` package
- Video IDs stored in JSON or synced from website
- No YouTube API key required (uses iframe embed)
- Platform support: Web, Android, iOS
