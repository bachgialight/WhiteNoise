import 'package:flutter/material.dart';

/// Represents a sound that can be played in the white noise app
class Sound {
  /// Unique identifier for the sound
  final String id;

  /// Display name of the sound
  final String name;

  /// Path to the audio file
  final String assetPath;

  /// Icon to represent the sound
  final IconData icon;

  /// Creates a new Sound instance
  Sound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
  });
}

/// Predefined list of sounds available in the app
List<Sound> getSounds() {
  return [
    Sound(
      id: 'rain',
      name: 'Rain',
      assetPath: 'assets/sounds/rain.mp3',
      icon: Icons.cloud,
    ),
    Sound(
      id: 'ocean',
      name: 'Ocean',
      assetPath: 'assets/sounds/ocean.mp3',
      icon: Icons.waves,
    ),
    Sound(
      id: 'forest',
      name: 'Forest',
      assetPath: 'assets/sounds/forest.mp3',
      icon: Icons.eco,
    ),
    Sound(
      id: 'fan',
      name: 'Fan',
      assetPath: 'assets/sounds/fan.mp3',
      icon: Icons.toys,
    ),
    Sound(
      id: 'fire',
      name: 'Fireplace',
      assetPath: 'assets/sounds/fire.mp3',
      icon: Icons.local_fire_department,
    ),
    Sound(
      id: 'birds',
      name: 'Birds',
      assetPath: 'assets/sounds/birds.mp3',
      icon: Icons.flight,
    ),
  ];
}
