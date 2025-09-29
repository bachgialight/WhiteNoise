import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/sound_model.dart';

/// Media service that handles audio playback with notification controls
class MediaService extends BaseAudioHandler {
  final _player = AudioPlayer();
  Sound? _currentSound;

  MediaService() {
    // Connect the player's state to the audio handler
    _player.playbackEventStream.listen((event) {
      playbackState.add(_transformEvent(event));
    });

    // Set up initial media controls
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  /// Plays a sound
  Future<void> playSound(Sound sound) async {
    // Stop current sound if playing
    if (_player.playing) {
      await _player.stop();
    }

    try {
      // Load and play the new sound
      await _player.setAsset(sound.assetPath);
      _player.setLoopMode(LoopMode.one); // Loop indefinitely
      await _player.play();
      _currentSound = sound;

      // Set media item
      mediaItem.add(
        MediaItem(
          id: sound.id,
          title: sound.name,
          artist: 'White Noise',
          album: 'Relaxation Sounds',
          duration: const Duration(
              hours: 1), // Set a long duration for looping sounds
        ),
      );

      // Update playback state
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.pause,
          MediaControl.stop,
        ],
        processingState: AudioProcessingState.ready,
        playing: true,
        updatePosition: Duration.zero,
      ));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  /// Pauses the current sound
  @override
  Future<void> pause() async {
    if (_player.playing) {
      await _player.pause();

      // Update playback state
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.play,
          MediaControl.stop,
        ],
        processingState: AudioProcessingState.ready,
        playing: false,
        updatePosition: _player.position,
      ));
    }
  }

  /// Resumes the current sound
  @override
  Future<void> play() async {
    if (!_player.playing && _currentSound != null) {
      await _player.play();

      // Update playback state
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.pause,
          MediaControl.stop,
        ],
        processingState: AudioProcessingState.ready,
        playing: true,
        updatePosition: _player.position,
      ));
    }
  }

  /// Stops the current sound
  @override
  Future<void> stop() async {
    if (_player.playing) {
      await _player.stop();
      _currentSound = null;

      // Update playback state
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.play,
        ],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
      ));
    }
  }

  /// Skips to the next track (not used in this app but required for media session)
  @override
  Future<void> skipToNext() async {
    // Not implemented for this app
  }

  /// Skips to the previous track (not used in this app but required for media session)
  @override
  Future<void> skipToPrevious() async {
    // Not implemented for this app
  }

  /// Seeks to a specific position (not used in this app but required for media session)
  @override
  Future<void> seek(Duration position) async {
    // Not implemented for this app
  }

  /// Checks if a sound is currently playing
  bool get isPlaying => _player.playing;

  /// Gets the currently playing sound
  Sound? get currentSound => _currentSound;

  /// Transform player events to playback states
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: _player.playing
          ? [MediaControl.pause, MediaControl.stop]
          : [MediaControl.play, MediaControl.stop],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
