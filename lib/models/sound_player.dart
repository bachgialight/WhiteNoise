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
  SoundPlayer() {
    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      debugPrint(
          'SoundPlayer: Player state changed to ${state.playing}, processingState: ${state.processingState}');
      onPlaybackStateChanged?.call(state.playing);
    });

    // Also listen to the playing stream directly
    _player.playingStream.listen((playing) {
      debugPrint('SoundPlayer: Playing stream changed to $playing');
      onPlaybackStateChanged?.call(playing);
    });
  }

  /// Plays the specified sound
  Future<void> playSound(Sound sound) async {
    debugPrint('SoundPlayer: playSound called for ${sound.name} (${sound.id})');
    debugPrint('SoundPlayer: currentSound before = ${_currentSound?.name}');
    debugPrint('SoundPlayer: player.playing before = ${_player.playing}');

    // If the same sound is already playing, stop it (toggle behavior)
    if (_currentSound?.id == sound.id && _player.playing) {
      debugPrint('SoundPlayer: Same sound is playing, stopping it (toggle)');
      await stopSound();
      return;
    }

    // If a different sound is playing, stop it
    if (_player.playing) {
      debugPrint('SoundPlayer: Different sound is playing, stopping it');
      await _player.stop();
    }

    try {
      debugPrint('SoundPlayer: Setting currentSound to ${sound.name}');
      // Set the current sound before loading
      _currentSound = sound;

      debugPrint('SoundPlayer: Loading asset ${sound.assetPath}');
      // Load and play the new sound
      await _player.setAsset(sound.assetPath);
      _player.setLoopMode(LoopMode.one); // Loop indefinitely
      await _player.play();
      debugPrint('SoundPlayer: Player started');
    } catch (e) {
      debugPrint('Error playing sound: $e');
      _currentSound = null; // Reset current sound on error
    }
  }

  /// Stops the currently playing sound
  Future<void> stopSound() async {
    if (_player.playing) {
      await _player.stop();
      _currentSound = null;
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
