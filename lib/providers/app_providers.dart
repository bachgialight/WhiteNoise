import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../viewmodels/white_noise_view_model.dart';

/// Provides all the view models for the app
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WhiteNoiseViewModel()..init(),
        ),
      ],
      child: child,
    );
  }
}
