import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'sound_model.dart';

/// Manages audio playback for the white noise app
class SoundPlayer {
  /// The audio player instance
  final AudioPlayer _player = AudioPlayer();

  /// The currently playing sound
  Sound? _currentSound;

  /// Timer for auto-stopping playback
  Timer? _timer;

  /// Callback when playback state changes
  Function(bool isPlaying)? onPlaybackStateChanged;

  /// Creates a new SoundPlayer instance
  SoundPlayer();

  /// Plays the specified sound
  Future<void> playSound(Sound sound) async {
    // If the same sound is already playing, pause it
    if (_currentSound?.id == sound.id && _player.playing) {
      await _player.pause();
      onPlaybackStateChanged?.call(false);
      return;
    }

    // If a different sound is playing, stop it
    if (_player.playing) {
      await _player.stop();
    }

    try {
      // Load and play the new sound
      await _player.setAsset(sound.assetPath);
      _player.setLoopMode(LoopMode.one); // Loop indefinitely
      await _player.play();
      _currentSound = sound;
      onPlaybackStateChanged?.call(true);
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  /// Stops the currently playing sound
  Future<void> stopSound() async {
    if (_player.playing) {
      await _player.stop();
      _currentSound = null;
      onPlaybackStateChanged?.call(false);
    }
    
    // Cancel any active timer
    _timer?.cancel();
    _timer = null;
  }

  /// Sets a sleep timer to automatically stop playback
  void setSleepTimer(Duration duration) {
    // Cancel any existing timer
    _timer?.cancel();
    
    // Set a new timer
    _timer = Timer(duration, () {
      stopSound();
    });
  }

  /// Returns the currently playing sound
  Sound? get currentSound => _currentSound;

  /// Checks if a sound is currently playing
  bool get isPlaying => _player.playing;

  /// Disposes of the player resources
  void dispose() {
    _player.dispose();
    _timer?.cancel();
  }
}