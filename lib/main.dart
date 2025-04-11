import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_screen.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/emhanced_bella_bot_screen.dart';
import 'package:robot_display_v2/home_screen.dart';
import 'package:robot_display_v2/wake_word/wake_word_detector.dart';

import 'screen/old_ai_bot.dart';

late List<CameraDescription> cameras;
late double screenHeight;
late double screenWidth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // Set to full-screen mode and hide status and navigation bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced BellaBot Face',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      home: Builder(
        builder: (context) {
          // Get screen dimensions and store in global variables
          final mediaQuery = MediaQuery.of(context);
          screenWidth = mediaQuery.size.width;
          screenHeight = mediaQuery.size.height;

          return BellaBotScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
