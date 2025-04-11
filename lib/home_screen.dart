// lib/features/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_screen.dart';
import 'package:robot_display_v2/features/gemeni_ai_agent/controller/gemini_controller.dart';
import 'package:robot_display_v2/features/speech/controller/voice_controller.dart';

import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Start wake word detection when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // Watch for wake word activation

    // Watch for active speech listening
    final isListening = ref.watch(speechListeningProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main robot face
          const BellaBotScreen(),

          // Status indicator for wake word and listening state
          Positioned(
            top: 40,
            right: 40,
            child: Column(
              children: [
                // Wake word indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                // Listening indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isListening ? Colors.red : Colors.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Full-screen gesture detector to manually trigger wake word (for testing)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  void _startSpeechRecognition() {
    ref
        .read(listenControllerProvider.notifier)
        .startListening(
          onRecognized: (text) {
            // Process recognized speech
            _processRecognizedSpeech(text);
          },
        );
  }

  void _processRecognizedSpeech(String text) {
    // Show thinking expression while processing
    ref
        .read(bellaBotExpressionProvider.notifier)
        .setExpression(ExpressionType.thinking);

    // Send to Gemini for processing
    final config = {"prompt": text, "max_tokens": 1000};
    ref
        .read(gemeniControllerProvider.notifier)
        .sendDataToGemini(config, context)
        .then((_) {
          // Mark command as completed once Gemini response is processed
          ref.read(listenControllerProvider.notifier).commandCompleted();
        });
  }

  @override
  void dispose() {
    // Make sure to stop wake word detection when the screen is disposed
    super.dispose();
  }
}
