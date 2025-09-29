import 'base_view_model.dart';
import '../models/sound_model.dart';
import '../models/sound_player.dart';
import '../models/favorites_manager.dart';
import '../services/media_notification_manager.dart';
import 'package:flutter/foundation.dart';

/// View model for the white noise app
/// Manages the state and business logic for the UI
class WhiteNoiseViewModel extends BaseViewModel {
  /// Audio player instance
  late SoundPlayer _soundPlayer;

  /// Favorites manager instance
  late FavoritesManager _favoritesManager;

  /// Media notification manager
  late MediaNotificationManager _mediaManager;

  /// List of all available sounds
  List<Sound> _sounds = [];

  /// Current tab index
  int _currentIndex = 0;

  /// Selected sleep timer duration
  Duration? _selectedTimer;

  /// Initializes the view model
  Future<void> init() async {
    _soundPlayer = SoundPlayer();
    _favoritesManager = FavoritesManager();
    _mediaManager = MediaNotificationManager();
    _sounds = getSounds();

    // Initialize the media notification manager
    await _mediaManager.init();

    // Set up callback for when sound stops from media notification
    _mediaManager.onSoundStopped = () {
      debugPrint('ViewModel: Sound stopped from media notification');
      // Stop the main sound player as well
      _soundPlayer.stopSound();
      // Notify listeners to update UI
      notifyListeners();
    };

    // Set up callbacks
    _soundPlayer.onPlaybackStateChanged = (isPlaying) {
      debugPrint(
          'ViewModel: onPlaybackStateChanged called with isPlaying=$isPlaying');
      notifyListeners();
    };

    _favoritesManager.onFavoritesChanged = (favorites) {
      notifyListeners();
    };

    // Initialize favorites manager
    await _favoritesManager.init();
  }

  /// Disposes of resources
  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  /// Gets the list of all sounds
  List<Sound> get sounds => _sounds;

  /// Gets the current tab index
  int get currentIndex => _currentIndex;

  /// Sets the current tab index
  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  /// Gets the currently playing sound
  Sound? get currentSound => _soundPlayer.currentSound;

  /// Checks if a sound is currently playing
  bool get isPlaying => _soundPlayer.isPlaying;

  /// Gets the selected timer duration
  Duration? get selectedTimer => _selectedTimer;

  /// Checks if a specific sound is currently playing
  bool isSoundPlaying(Sound sound) {
    return currentSound?.id == sound.id && _soundPlayer.isPlaying;
  }

  /// Plays a sound
  void playSound(Sound sound) {
    debugPrint('ViewModel: playSound called for ${sound.name} (${sound.id})');
    debugPrint(
        'ViewModel: currentSound before = ${_soundPlayer.currentSound?.name}');
    debugPrint('ViewModel: isPlaying before = ${_soundPlayer.isPlaying}');

    // Check if this is the same sound that's already playing (toggle behavior)
    bool isSameSoundPlaying =
        _soundPlayer.currentSound?.id == sound.id && _soundPlayer.isPlaying;

    _soundPlayer.playSound(sound);

    if (isSameSoundPlaying) {
      // If we're stopping the same sound, also stop media notification
      debugPrint(
          'ViewModel: Stopping same sound, also stopping media notification');
      _mediaManager.stopSound();
    } else {
      // If we're playing a new sound, also play with media notification
      debugPrint(
          'ViewModel: Playing new sound, also playing with media notification');
      _mediaManager.playSound(sound);
    }

    debugPrint(
        'ViewModel: currentSound after = ${_soundPlayer.currentSound?.name}');
    debugPrint('ViewModel: isPlaying after = ${_soundPlayer.isPlaying}');

    // Gọi notifyListeners() ngay lập tức để cập nhật UI
    notifyListeners();
    debugPrint('ViewModel: notifyListeners called');
  }

  /// Stops the currently playing sound
  void stopSound() {
    _soundPlayer.stopSound();
    // Also stop media notification
    _mediaManager.stopSound();
    notifyListeners();
  }

  /// Handles when sound is stopped from external source (like media notification)
  void handleExternalStop() {
    debugPrint('ViewModel: handleExternalStop called');
    // Stop the main sound player
    _soundPlayer.stopSound();
    // Notify listeners to update UI
    notifyListeners();
  }

  /// Checks if a sound is marked as favorite
  bool isFavorite(String soundId) {
    return _favoritesManager.isFavorite(soundId);
  }

  /// Toggles the favorite status of a sound
  void toggleFavorite(String soundId) {
    _favoritesManager.toggleFavorite(soundId);
    notifyListeners();
  }

  /// Gets the list of favorite sounds
  List<Sound> get favoriteSounds {
    return _favoritesManager.getFavoriteSounds(_sounds);
  }

  /// Sets a sleep timer
  void setSleepTimer(Duration duration) {
    _soundPlayer.setSleepTimer(duration);
    _selectedTimer = duration;
    notifyListeners();
  }
}
