import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/white_noise_view_model.dart';
import '../models/sound_model.dart';

/// View that displays a grid of sounds
class SoundsGridView extends StatelessWidget {
  final List<Sound> sounds;

  const SoundsGridView({super.key, required this.sounds});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WhiteNoiseViewModel>(context, listen: false);

    if (sounds.isEmpty) {
      return const Center(
        child: Text('No sounds available'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        final isPlaying =
            viewModel.currentSound?.id == sound.id && viewModel.isPlaying;
        final isFavorite = viewModel.isFavorite(sound.id);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => viewModel.playSound(sound),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isPlaying ? Colors.blueGrey[700] : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    sound.icon,
                    size: 48,
                    color: isPlaying ? Colors.white : Colors.blueGrey[200],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sound.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPlaying ? Colors.white : Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[400],
                      ),
                      onPressed: () => viewModel.toggleFavorite(sound.id),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                    if (isPlaying)
                      const Icon(
                        Icons.volume_up,
                        color: Colors.green,
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
