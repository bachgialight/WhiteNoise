import 'package:flutter/material.dart';
import '../viewmodels/white_noise_view_model.dart';

/// View for the sleep timer dialog
class TimerDialogView extends StatelessWidget {
  final WhiteNoiseViewModel viewModel;

  const TimerDialogView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Sleep Timer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('15 minutes'),
            trailing: viewModel.selectedTimer == const Duration(minutes: 15)
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              viewModel.setSleepTimer(const Duration(minutes: 15));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('30 minutes'),
            trailing: viewModel.selectedTimer == const Duration(minutes: 30)
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              viewModel.setSleepTimer(const Duration(minutes: 30));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('1 hour'),
            trailing: viewModel.selectedTimer == const Duration(hours: 1)
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              viewModel.setSleepTimer(const Duration(hours: 1));
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Cancel Timer'),
            onTap: () {
              viewModel.stopSound();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
