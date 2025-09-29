import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/white_noise_view_model.dart';
import 'sounds_grid_view.dart';
import 'timer_dialog_view.dart';

/// Main view for the white noise app
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WhiteNoiseViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('White Noise'),
            actions: [
              IconButton(
                icon: const Icon(Icons.timer),
                onPressed: () => _showTimerDialog(context, viewModel),
              ),
            ],
          ),
          body: viewModel.currentIndex == 0
              ? SoundsGridView(sounds: viewModel.sounds)
              : SoundsGridView(sounds: viewModel.favoriteSounds),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.currentIndex,
            onTap: (index) {
              viewModel.currentIndex = index;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Sounds',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows the sleep timer dialog
  void _showTimerDialog(BuildContext context, WhiteNoiseViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimerDialogView(viewModel: viewModel);
      },
    );
  }
}
