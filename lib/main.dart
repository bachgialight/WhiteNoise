import 'package:flutter/material.dart';
import 'providers/app_providers.dart';
import 'views/home_view.dart';
import 'services/media_notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media notification manager
  final mediaManager = MediaNotificationManager();
  await mediaManager.init();

  runApp(const WhiteNoiseApp());
}

class WhiteNoiseApp extends StatelessWidget {
  const WhiteNoiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: 'White Noise Relaxation',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.grey[900],
          cardColor: Colors.grey[800],
        ),
        home: const HomeView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
