import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import '../models/sound_model.dart';
import 'media_service.dart';

/// Manages media notifications for the white noise app
class MediaNotificationManager {
  static final MediaNotificationManager _instance =
      MediaNotificationManager._internal();

  factory MediaNotificationManager() => _instance;

  MediaNotificationManager._internal();

  MediaService? _mediaService;
  bool _initialized = false;

  /// Initializes the audio service
  Future<void> init() async {
    if (_initialized) return;

    try {
      _mediaService = await AudioService.init(
        builder: () => MediaService(),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing audio service: $e');
    }
  }

  /// Plays a sound with media notification
  Future<void> playSound(Sound sound) async {
    if (!_initialized) {
      await init();
    }

    try {
      // Play the sound through the media service
      if (_mediaService != null) {
        await _mediaService!.playSound(sound);
      }
    } catch (e) {
      debugPrint('Error playing sound with media notification: $e');
    }
  }

  /// Pauses the current sound
  Future<void> pauseSound() async {
    try {
      if (_mediaService != null) {
        await _mediaService!.pause();
      }
    } catch (e) {
      debugPrint('Error pausing sound: $e');
    }
  }

  /// Resumes the current sound
  Future<void> resumeSound() async {
    try {
      if (_mediaService != null) {
        await _mediaService!.play();
      }
    } catch (e) {
      debugPrint('Error resuming sound: $e');
    }
  }

  /// Stops the current sound and stops the service
  Future<void> stopSound() async {
    try {
      if (_mediaService != null) {
        await _mediaService!.stop();
      }
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  /// Checks if audio is currently playing
  bool get isPlaying {
    try {
      return _mediaService?.isPlaying ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Gets the currently playing sound
  Sound? get currentSound => _mediaService?.currentSound;
}
