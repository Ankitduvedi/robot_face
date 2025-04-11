// First, define your controller state
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeakState {
  final bool isSpeaking;
  final String currentText;
  final String? error;

  const SpeakState({
    this.isSpeaking = false,
    this.currentText = '',
    this.error,
  });

  SpeakState copyWith({bool? isSpeaking, String? currentText, String? error}) {
    return SpeakState(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      currentText: currentText ?? this.currentText,
      error: error, // Null means remove error
    );
  }
}

// Define your controller
class SpeakController extends StateNotifier<SpeakState> {
  late final FlutterTts _flutterTts;

  SpeakController() : super(const SpeakState()) {
    _initializeTts();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setSpeechRate(0.5);

    _flutterTts.setCompletionHandler(() {
      state = state.copyWith(isSpeaking: false);
    });

    _flutterTts.setStartHandler(() {
      state = state.copyWith(isSpeaking: true);
    });

    _flutterTts.setErrorHandler((error) {
      state = state.copyWith(isSpeaking: false, error: error.toString());
    });
  }

  // Method to speak text
  Future<void> speak(String text) async {
    try {
      // Update state with the new text
      state = state.copyWith(currentText: text, error: null);

      // Start speaking
      await _flutterTts.speak(text);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isSpeaking: false);
      log('Error speaking: $e');
    }
  }

  // Method to stop speaking
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      state = state.copyWith(isSpeaking: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      log('Error stopping speech: $e');
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}

// Create the provider
final speakControllerProvider =
    StateNotifierProvider<SpeakController, SpeakState>((ref) {
      return SpeakController();
    });

// Then you can use it like this:
// ref.read(speakControllerProvider.notifier).speak("Your text here");
