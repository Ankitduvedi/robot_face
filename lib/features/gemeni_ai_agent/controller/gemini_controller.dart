// item_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/data/utils.dart';
import 'package:robot_display_v2/features/gemeni_ai_agent/repository/gemini_repository.dart';
import 'package:robot_display_v2/features/speech/controller/speak_controller.dart';

// Create a StateNotifier for managing the state and interactions
class GeminiController extends StateNotifier<bool> {
  final GemininRepository gemininRepository;
  final Ref ref;

  GeminiController(this.gemininRepository, this.ref) : super(false);

  Future<String> sendDataToGemini(config, BuildContext context) async {
    try {
      state = true;
      final response = await gemininRepository.addAttribute(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        state = false;
        ref.read(speakControllerProvider.notifier).speak(r.toString());

        return r.toString();
      });

      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
      return e.toString();
    }
    return '';
  }
}

// Define a provider for the controller
final gemeniControllerProvider = StateNotifierProvider<GeminiController, bool>((
  ref,
) {
  final repository = GemininRepository();
  return GeminiController(repository, ref);
});
