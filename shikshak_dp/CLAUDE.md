# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Shikshak DP (Bhaja Govindam App)** - A Flutter mobile application presenting all 33 shlokas (verses) from "Bhaja Govindam," a famous Sanskrit devotional composition by Adi Shankaracharya. The app features an animated book-opening intro screen followed by an interactive display of each shloka with Devanagari script, English transliteration, word-by-word meanings, and philosophical commentary.

## Architecture

### Application Flow
1. **Book Intro Screen** (`lib/book_intro_screen.dart`):
   - Animated landing screen with 3D book-opening animation
   - User taps the book to trigger a flip animation (1500ms duration)
   - Uses `AnimationController` and `Matrix4` transformations for 3D effects
   - Transitions to main shloka list after animation completes

2. **Main List Screen** (`lib/main.dart` - `BhajaGovindamHomePage`):
   - Displays all 33 shlokas as palm leaf manuscript-styled cards in a scrollable `ListView`
   - Uses `FutureBuilder` to handle async JSON loading from assets
   - Cards styled with aged beige/brown tones (#E8DCC4, #B8945F) resembling ancient palm leaf manuscripts
   - Each card has decorative texture lines, aging spots, and wear effects for authenticity
   - Cards show shloka number with "Tap to read more" hint
   - Navigation via `Navigator.push()` to detail screen

3. **Detail Screen** (`lib/shloka_detail_screen.dart`):
   - Four interactive flip cards showing different content types
   - 3D flip animation (600ms) when card is tapped using `TweenAnimationBuilder`
   - Content types: Devanagari, Transliteration, Word Meaning, Commentary
   - Special formatting: Devanagari/Transliteration centered with line breaks at verse markers
   - Back button returns to main list

### State Management Pattern
- **Root App State** (`MyApp` - StatefulWidget): Manages book intro visibility
- **Local State**: Uses `StatefulWidget` with `setState()` for screen-level state
- **No external state management**: No Provider, BLoC, Riverpod, GetX, etc.
- **Animations**: `AnimationController` with `SingleTickerProviderStateMixin`

### Data Layer
- **Model**: `lib/model/shloka_model.dart` - Simple data class with `fromJson()` factory
- **Data Source**: JSON asset loaded via `rootBundle.loadString()`
- **Parsing**: Direct JSON deserialization using `Shloka.fromJson()`
- **No persistence**: Data exists only in memory during runtime

### UI/UX Design System

**Theme Configuration** (in `MyApp`):
```
Primary: deepPurple
Scaffold Background: grey[50]
Gradients: purple[700] → deepPurple[400] → orange[300]
```

**Card Gradients** (3 alternating patterns):
- Pattern 1: purple[400] → deepPurple[600]
- Pattern 2: orange[400] → deepOrange[600]
- Pattern 3: amber[400] → orange[600]

**Typography**:
- Title (Bhaja Govindam): 32pt, bold, white, letter-spacing 1.2
- Author: 16pt, italic, white (90% opacity)
- Shloka numbers: 20pt, bold, white
- Devanagari content: 18pt, 2.0 line height, centered
- Other content: 14pt, 1.6 line height, left-aligned

**Animations**:
- Book opening: 1500ms with `Curves.easeInOut`
- Card flips: 600ms with `Curves.easeInOut`
- 3D transformations using `Matrix4.rotateX()` and `Matrix4.rotateY()`

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
flutter analyze                          # Run static analysis
dart format lib test                     # Format code

# Maintenance
flutter clean                            # Remove build artifacts
flutter doctor                           # Verify Flutter installation
```

## Project Structure

```
lib/
├── main.dart                      # App entry, state management, list screen
├── book_intro_screen.dart         # Animated book-opening intro
├── shloka_detail_screen.dart      # Detail view with flip cards
└── model/
    └── shloka_model.dart          # Data model with JSON parsing

assets/
└── bhaja_govindam.json            # 33 shlokas data

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
  "Commentary": "This verse presents..."
}
```

**CRITICAL PARSING DETAIL**:
- The `" Transliteration"` key has a **leading space** - this is intentional and handled in `shloka_model.dart:22`
- If you edit the JSON, preserve this space or the app will crash with a null parsing error
- All five fields are required for each shloka

**Text Formatting Logic**:
- **Devanagari**: Line breaks at `।` (danda), removes `॥` (double danda)
- **Transliteration**: Line breaks at `|` and `||`, removes verse numbers like `|| 1 ||`
- **Word Meaning & Commentary**: No special formatting, displayed as-is

## Dependencies

**Production**:
- `flutter` (SDK)
- `cupertino_icons: ^1.0.8`

**Dev**:
- `flutter_test` (SDK)
- `flutter_lints: ^5.0.0`

**SDK Requirements**: Dart ^3.9.2

## Animation Implementation Details

### Book Opening Animation
- **Controller**: 1500ms duration
- **Transform**: `Matrix4.rotateY()` from 0 to π/2 radians
- **Opacity**: Fades cover from 1 to 0 during flip
- **Scale**: Book grows by 30% during animation
- **Callback**: Calls `onBookOpened()` 300ms after completion

### Flip Card Animation
- **Builder**: `TweenAnimationBuilder<double>` with 600ms duration
- **Transform**: `Matrix4.rotateX()` from 0 to π radians
- **Front Face**: Shows icon + label with centered layout
- **Back Face**: Shows full content with scrollable text (uses `Transform.rotateX(π)` to flip content)
- **State Toggle**: Tapping a flipped card closes it, tapping a new card opens it

### Shadow & Depth Effects
- Book shadow adjusts opacity based on animation progress
- Cards have colored shadows matching gradient colors
- `setEntry(3, 2, 0.001)` adds perspective to 3D transforms

## Adding New Features

### Adding a New Content Type to Shlokas
1. Add new field to `Shloka` class in `lib/model/shloka_model.dart`
2. Update `fromJson()` factory to parse the field
3. Add field to all 33 entries in `assets/bhaja_govindam.json`
4. Add new enum value to `ContentType` in `shloka_detail_screen.dart`
5. Add case to `_formatContent()` switch statement
6. Add new flip card by calling `_buildFlipCard()` in the detail screen `Column`

### Modifying Animations
- Book opening duration: `_controller` duration in `book_intro_screen.dart:23`
- Flip card duration: `duration` in `TweenAnimationBuilder` at `shloka_detail_screen.dart:190`
- Animation curves: Modify `CurvedAnimation` curve parameter

### Changing Colors/Theme
- App-wide gradients: `MaterialApp` theme in `main.dart:32`
- Card gradient colors: `_getGradientColor1()` and `_getGradientColor2()` in `main.dart:165-173`
- Detail screen gradients: Modify color arrays in `_buildFlipCard()` calls at `shloka_detail_screen.dart:144-166`

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
5. **Animation State**: Book intro shows every app restart (not persisted)

## Testing Strategy

Current test coverage is minimal. Recommended tests:

**Unit Tests**:
- `Shloka.fromJson()` parsing (including space handling)
- `loadShlokas()` async loading
- Content formatting logic in `_formatContent()`

**Widget Tests**:
- Book intro animation sequence
- Shloka list rendering with correct count
- Navigation to detail screen
- Flip card state management

**Integration Tests**:
- End-to-end flow: intro → list → detail → back
- Multiple card flips in detail screen
- JSON loading error handling
