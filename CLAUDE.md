# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Bhaja Govindam Flutter App** - A mobile application displaying all 33 shlokas (verses) from Bhaja Govindam, a famous Sanskrit devotional composition by Adi Shankaracharya. The app presents each shloka with Devanagari script, English transliteration, word-by-word meanings, and philosophical commentary.

**Project Directory**: `shikshak_dp/` (the actual Flutter project is in this subdirectory)

## Architecture

### Data Model Pattern
- **Single Model Class**: `lib/model/shloka_model.dart` defines the `Shloka` class
- **JSON Parsing**: Uses factory constructor `Shloka.fromJson()` to deserialize data
- **Asset Loading**: Data loaded from `assets/bhaja_govindam.json` at runtime

### Screen Structure
1. **Main List Screen** (`lib/main.dart`):
   - Displays all 33 shlokas as a scrollable list using `ListView.builder`
   - Uses `FutureBuilder` to handle async JSON loading
   - Each item is a `Card` with `ListTile` showing the shloka number
   - Tapping a shloka navigates to detail screen

2. **Detail Screen** (`lib/shloka_detail_screen.dart`):
   - Shows detailed information for a selected shloka
   - Uses enum `ContentType` to manage which content section is displayed
   - Four toggle buttons: Devanagari, Transliteration, Word Meaning, Commentary
   - Content updates via `setState()` when buttons are pressed

### Key Implementation Details
- **JSON Key Quirk**: The JSON file has a leading space in the key `" Transliteration"` (note the space). This is handled correctly in the model's `fromJson` method.
- **Navigation**: Standard `Navigator.push()` with `MaterialPageRoute`
- **State Management**: Simple `StatefulWidget` with local state (no external state management)

## Common Development Commands

**Important**: All Flutter commands must be run from the `shikshak_dp/` directory, not the repository root.

### Setup and Dependencies
```bash
cd shikshak_dp
flutter pub get                  # Install dependencies
flutter doctor                   # Verify Flutter installation and dependencies
```

### Running the App
```bash
flutter run                      # Run on connected device/emulator
flutter run -d chrome            # Run in Chrome browser
flutter run -d windows           # Run as Windows desktop app
flutter devices                  # List available devices
```

### Building
```bash
flutter build apk                # Build Android APK (release)
flutter build appbundle          # Build Android App Bundle for Play Store
flutter build ios                # Build iOS app (requires macOS)
flutter build windows            # Build Windows desktop app
```

### Testing and Analysis
```bash
flutter test                     # Run all tests
flutter test test/widget_test.dart  # Run specific test file
flutter analyze                  # Run static analysis
```

**Note**: The current `test/widget_test.dart` contains the default Flutter counter app test and needs to be updated to test the actual Bhaja Govindam app functionality.

### Cleaning
```bash
flutter clean                    # Remove build artifacts
flutter pub get                  # Re-fetch dependencies after clean
```

## Project Structure

```
shikshak_dp/
├── lib/
│   ├── main.dart                      # Entry point, main list screen
│   ├── shloka_detail_screen.dart      # Detail view for individual shlokas
│   └── model/
│       └── shloka_model.dart          # Data model with JSON parsing
├── assets/
│   └── bhaja_govindam.json            # All 33 shlokas data
├── test/
│   └── widget_test.dart               # Widget tests
├── android/                           # Android-specific configuration
├── ios/                               # iOS-specific configuration
├── windows/                           # Windows desktop configuration
├── web/                               # Web configuration
├── pubspec.yaml                       # Dependencies and asset declarations
└── analysis_options.yaml              # Dart linter configuration
```

## Dependencies

### Production Dependencies
- `flutter` (SDK)
- `cupertino_icons: ^1.0.8` - iOS-style icons

### Dev Dependencies
- `flutter_test` (SDK)
- `flutter_lints: ^5.0.0` - Recommended linting rules

**Note**: This is a minimal Flutter app with very few external dependencies.

## Data Format

The `assets/bhaja_govindam.json` file contains an array of exactly 33 objects (one for each shloka) with this structure:
```json
{
  "Solka no.": "Solka 1",
  "Devanagari": "भज गोविन्दं...",
  " Transliteration": "bhaja govindaṃ...",
  "Word-to-Word Meaning": "भज (bhaja) – worship...",
  "Commentary": "This verse presents..."
}
```

**Critical Data Constraints**:
- **Leading space**: The `" Transliteration"` key has a leading space - this must be preserved when editing the JSON file or the app will fail to parse it.
- **Shloka count**: The app expects 33 entries. Adding or removing entries is supported, but be aware the app title/description references "all 33 shlokas".
- **Required fields**: All five JSON keys must be present for each entry or the app will throw an error during deserialization.

## Development Guidelines

### Adding New Shlokas
1. Add the shloka entry to `assets/bhaja_govindam.json`
2. Ensure all five keys are present with correct spelling (including the space in `" Transliteration"`)
3. No code changes needed - the app dynamically loads all entries

### Modifying UI
- Main list appearance: Edit `main.dart`, modify the `Card`/`ListTile` widget
- Detail screen layout: Edit `shloka_detail_screen.dart`, modify the `Column` and button `Wrap`
- App title: Change the `AppBar` title in `main.dart`

### Adding New Fields to Shloka Model
1. Add property to `Shloka` class in `lib/model/shloka_model.dart`
2. Update the `fromJson` factory constructor to parse the new field
3. Add the field to JSON data in `assets/bhaja_govindam.json`
4. Update `pubspec.yaml` if needed (though assets are already declared)
5. Create a new button in `shloka_detail_screen.dart` if you want to display the field
6. Add corresponding enum value to `ContentType` and handle in `_buildContent()`

## SDK Requirements

- **Dart SDK**: ^3.9.2 (specified in pubspec.yaml)
- **Flutter**: Ensure compatible Flutter version is installed (run `flutter doctor` to verify)

## Platform Support

This app is configured for:
- Android
- iOS
- Web
- Linux
- macOS
- Windows

All platform folders are present and configured with default settings.

## Linting

The project uses `package:flutter_lints/flutter.yaml` for recommended Flutter linting rules. Run `flutter analyze` to check for issues.
