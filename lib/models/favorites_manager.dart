import 'package:shared_preferences/shared_preferences.dart';
import 'sound_model.dart';

/// Manages the user's favorite sounds using local storage
class FavoritesManager {
  /// Key for storing favorites in shared preferences
  static const String _favoritesKey = 'favorite_sounds';

  /// Singleton instance
  static final FavoritesManager _instance = FavoritesManager._internal();

  /// Factory constructor for singleton pattern
  factory FavoritesManager() => _instance;

  /// Internal constructor
  FavoritesManager._internal();

  /// List of favorite sound IDs
  final List<String> _favorites = [];

  /// Callback when favorites change
  Function(List<String> favorites)? onFavoritesChanged;

  /// Initializes the favorites manager by loading saved favorites
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
    _favorites.clear();
    _favorites.addAll(favoritesList);
    onFavoritesChanged?.call(_favorites);
  }

  /// Checks if a sound is marked as favorite
  bool isFavorite(String soundId) {
    return _favorites.contains(soundId);
  }

  /// Adds a sound to favorites
  Future<void> addFavorite(String soundId) async {
    if (!_favorites.contains(soundId)) {
      _favorites.add(soundId);
      await _saveFavorites();
      onFavoritesChanged?.call(_favorites);
    }
  }

  /// Removes a sound from favorites
  Future<void> removeFavorite(String soundId) async {
    if (_favorites.remove(soundId)) {
      await _saveFavorites();
      onFavoritesChanged?.call(_favorites);
    }
  }

  /// Toggles the favorite status of a sound
  Future<void> toggleFavorite(String soundId) async {
    if (isFavorite(soundId)) {
      await removeFavorite(soundId);
    } else {
      await addFavorite(soundId);
    }
  }

  /// Gets the list of favorite sounds from the full sounds list
  List<Sound> getFavoriteSounds(List<Sound> allSounds) {
    return allSounds.where((sound) => isFavorite(sound.id)).toList();
  }

  /// Saves the current favorites to shared preferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites);
  }
}