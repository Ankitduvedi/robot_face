// lib/features/speech/controller/voice_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';

// Provider for speech recognition state
final speechListeningProvider = StateProvider<bool>((ref) => false);

// Provider for the voice controller
final listenControllerProvider = StateNotifierProvider<VoiceController, bool>((
  ref,
) {
  return VoiceController(ref);
});

class VoiceController extends StateNotifier<bool> {
  final Ref ref;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  VoiceController(this.ref) : super(false) {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _isInitialized = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
  }

  void _onSpeechStatus(String status) {
    if (status == 'listening') {
      state = true;
      ref.read(speechListeningProvider.notifier).state = true;
      ref
          .read(bellaBotExpressionProvider.notifier)
          .setExpression(ExpressionType.surprised);
    } else if (status == 'notListening' || status == 'done') {
      state = false;
      ref.read(speechListeningProvider.notifier).state = false;
      ref
          .read(bellaBotExpressionProvider.notifier)
          .setExpression(ExpressionType.neutral);
    }
  }

  void _onSpeechError(dynamic error) {
    state = false;
    ref.read(speechListeningProvider.notifier).state = false;
    ref
        .read(bellaBotExpressionProvider.notifier)
        .setExpression(ExpressionType.confused);
    print('Speech recognition error: $error');

    // Resume wake word detection after an error
  }

  Future<void> startListening({
    required Function(String) onRecognized,
    String localeId = 'en_IN', // Default to Indian English
  }) async {
    // Check if wake word is active, if not, don't start speech recognition

    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );
    }

    if (_isInitialized) {
      // Pause wake word detection while we're doing full speech recognition

      // Set face to an attentive expression
      ref
          .read(bellaBotExpressionProvider.notifier)
          .setExpression(ExpressionType.surprised);

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            state = false;
            ref.read(speechListeningProvider.notifier).state = false;

            // Process the recognized text
            if (result.recognizedWords.isNotEmpty) {
              onRecognized(result.recognizedWords);

              // Show processing expression
              ref
                  .read(bellaBotExpressionProvider.notifier)
                  .setExpression(ExpressionType.thinking);
            } else {
              // No speech detected, resume wake word detection
            }
          }
        },
        localeId: localeId,
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );

      state = true;
      ref.read(speechListeningProvider.notifier).state = true;
    }
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
      state = false;
      ref.read(speechListeningProvider.notifier).state = false;
    }

    // Resume wake word detection
  }

  // Call this when a command has been successfully processed
  void commandCompleted() {
    // Reset the wake word state and resume listening for wake words
  }

  @override
  void dispose() {
    stopListening();

    super.dispose();
  }
}
