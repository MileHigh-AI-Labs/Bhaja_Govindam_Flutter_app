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
   - Top bar with menu, notifications, and search icons (currently non-functional)
   - Profile badge showing "Seeker" greeting
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
- **No persistence**: Data exists only in memory during runtime
- **Meaningful Labels**: Each shloka has a meaningful label (e.g., "Worship Govinda", "True Contentment") defined in `BhajaGovindamHomePage.shlokaLabels` array (main.dart:33-42) that summarizes the essence of that verse

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
├── main.dart                      # App entry, shloka list screen
├── home_screen.dart               # Landing/intro screen
├── shloka_detail_screen.dart      # Detail view with flip cards
└── model/
    └── shloka_model.dart          # Data model with JSON parsing

assets/
├── bhaja_govindam.json            # 33 shlokas data
└── shankaracharya.png             # Image asset (referenced but not used)

test/
└── widget_test.dart               # Widget tests (needs updating)
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
- `cupertino_icons: ^1.0.8`
- `url_launcher: ^6.3.1` - URL launcher (legacy, kept for compatibility)
- `youtube_player_iframe: ^5.2.0` - Cross-platform YouTube iframe player (works on web and mobile)

**Dev**:
- `flutter_test` (SDK)
- `flutter_lints: ^5.0.0`

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
- **Platform Support**: Works on both web (Chrome, Edge) and mobile (Android, iOS)
- **Behavior**:
  - Shows "Play Audio" button when player is hidden
  - Clicking button toggles embedded YouTube iframe player within the app
  - Player stays within the app (no external redirect)
  - Close button (X icon) appears when player is visible to hide it
  - Auto-play disabled by default (user must click play in the player)
- **Video ID**: Uses `audioUrl` field from JSON (e.g., "PWa7Fv4nX6A")
- **Player Configuration**:
  - Fixed height: 220px with 16:9 aspect ratio
  - Controls enabled (play, pause, volume, progress bar)
  - Fullscreen button enabled
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

## Known Issues & Quirks

1. **JSON Leading Space**: The `" Transliteration"` key has a leading space - intentional but unusual
2. **Default Test**: `test/widget_test.dart` still contains counter app template - needs replacement
3. **No Error Handling**: JSON parsing assumes perfect data - malformed JSON will crash the app
4. **No Offline Indicator**: App is fully offline but doesn't communicate this to users
5. **Unused Icons**: Home screen has menu, notifications, and search icons that are not yet functional
6. **Unused Asset**: `shankaracharya.png` image asset is declared but not currently displayed in the app
7. **Network Image**: Home screen featured card attempts to load background image from Unsplash but has fallback to transparent

## Testing Strategy

Current test coverage is minimal. Recommended tests:

**Unit Tests**:
- `Shloka.fromJson()` parsing (including space handling)
- `loadShlokas()` async loading
- Content formatting logic in `_formatContent()`

**Widget Tests**:
- Home screen rendering and navigation
- Shloka list rendering with correct count
- Navigation between screens
- Flip card state management
- YouTube player toggle functionality
- YoutubePlayerController initialization and video loading

**Integration Tests**:
- End-to-end flow: home → list → detail → back navigation
- Multiple card flips in detail screen
- JSON loading error handling
