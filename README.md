# White Noise Relaxation App

A simple MVP white noise relaxation app built with Flutter.

## Features

- Play various ambient sounds (Rain, Ocean, Forest, Fan, etc.)
- Sleep timer (15min, 30min, 1h)
- Mark sounds as favorites
- Clean dark mode UI
- Only one sound plays at a time

## Getting Started

1. Add MP3 files to the `assets/sounds/` folder:
   - rain.mp3
   - ocean.mp3
   - forest.mp3
   - fan.mp3
   - fire.mp3
   - birds.mp3

2. Run the following commands:
   ```
   flutter pub get
   flutter run
   ```

## Dependencies

- [just_audio](https://pub.dev/packages/just_audio) - For audio playback
- [shared_preferences](https://pub.dev/packages/shared_preferences) - For saving favorites locally

## Project Structure

- `lib/main.dart` - Main app and UI
- `lib/sound_model.dart` - Sound data model
- `lib/sound_player.dart` - Audio playback management
- `lib/favorites_manager.dart` - Favorites handling

## Supported Sounds

1. Rain (`rain.mp3`)
2. Ocean (`ocean.mp3`)
3. Forest (`forest.mp3`)
4. Fan (`fan.mp3`)
5. Fireplace (`fire.mp3`)
6. Birds (`birds.mp3`)

To add your own sounds, place the MP3 files in the `assets/sounds/` directory and ensure they match the filenames listed above.