// lib/utils/animation_manager.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';

class BellaBotAnimationManager {
  final TickerProvider vsync;
  final WidgetRef ref;
  late AnimationController blinkController;
  late AnimationController bounceController;
  late AnimationController floatController;
  late AnimationController emotionTransitionController;
  late Animation<double> floatAnimation;

  Timer? blinkTimer;
  Timer? emotionTimer;
  final Random random = Random();

  BellaBotAnimationManager({required this.vsync, required this.ref}) {
    _initializeControllers();
    _setupAnimations();
    _startAnimations();
  }

  void _initializeControllers() {
    // Blink animation controller
    blinkController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );

    // Subtle bounce animation for the whole face
    bounceController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );

    // Floating animation for a gentle hovering effect
    floatController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 3),
    );

    // Controller for smooth transitions between expressions
    emotionTransitionController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setupAnimations() {
    // Configure the float animation
    floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    // Add listeners for controllers to update providers
    blinkController.addListener(_updateBlinkState);
    bounceController.addListener(_updateBounceState);
    floatAnimation.addListener(_updateFloatState);
  }

  void _startAnimations() {
    // Start the repeating animations
    bounceController.repeat(reverse: true);
    floatController.repeat(reverse: true);

    // Schedule random blinking
    _scheduleRandomBlink();

    // Schedule occasional random expressions
    _scheduleRandomEmotions();
  }

  void _updateBlinkState() {
    ref.read(blinkingProvider.notifier).state = blinkController.value > 0.5;
  }

  void _updateBounceState() {
    ref
        .read(animationStateProvider.notifier)
        .update((state) => state.copyWith(bounceValue: bounceController.value));
  }

  void _updateFloatState() {
    ref
        .read(animationStateProvider.notifier)
        .update((state) => state.copyWith(floatValue: floatAnimation.value));
  }

  void _scheduleRandomBlink() {
    // Random time between blinks for natural effect
    final nextBlinkDelay = Duration(milliseconds: 2000 + random.nextInt(4000));
    blinkTimer = Timer(nextBlinkDelay, () {
      blink();
      _scheduleRandomBlink();
    });
  }

  void _scheduleRandomEmotions() {
    emotionTimer = Timer.periodic(Duration(seconds: 8 + random.nextInt(8)), (
      _,
    ) {
      if (random.nextDouble() > 0.6) {
        // 40% chance of random expression
        _showRandomEmotion();
      }
    });
  }

  void blink() {
    blinkController.forward().then((_) {
      blinkController.reverse();
    });
  }

  void _showRandomEmotion() {
    final expressions = ExpressionType.values;
    // Choose a random expression, excluding current one to ensure a change
    ExpressionType randomExpression;
    do {
      randomExpression = expressions[random.nextInt(expressions.length)];
    } while (randomExpression == ref.read(bellaBotExpressionProvider).type);

    // Change the expression
    ref
        .read(bellaBotExpressionProvider.notifier)
        .setExpression(randomExpression);

    // For most expressions, return to neutral after a while
    if (randomExpression != ExpressionType.neutral &&
        randomExpression != ExpressionType.happy &&
        randomExpression != ExpressionType.sleepy) {
      Timer(Duration(milliseconds: 2000 + random.nextInt(3000)), () {
        ref
            .read(bellaBotExpressionProvider.notifier)
            .setExpression(ExpressionType.neutral);
      });
    }
  }

  // Method to trigger specific emotions
  void triggerEmotion(ExpressionType emotion) {
    ref.read(bellaBotExpressionProvider.notifier).setExpression(emotion);
  }

  // Make the face look in a specific direction
  void lookAt(Offset position, {double maxDistance = 8.0}) {
    // Convert screen position to normalized pupil position
    // This would use actual screen dimensions in a real app
    final screenWidth = 400.0;
    final screenHeight = 800.0;

    final normalizedX =
        (position.dx / screenWidth) * maxDistance - maxDistance / 2;
    final normalizedY =
        (position.dy / screenHeight) * maxDistance - maxDistance / 2;

    // Cap the position within the allowed range
    final maxEyeDistance = maxDistance / 2;
    final distance = sqrt(
      normalizedX * normalizedX + normalizedY * normalizedY,
    );

    if (distance > maxEyeDistance) {
      final angle = atan2(normalizedY, normalizedX);
      final adjustedX = cos(angle) * maxEyeDistance;
      final adjustedY = sin(angle) * maxEyeDistance;
      ref.read(eyePupilPositionProvider.notifier).state = Offset(
        adjustedX,
        adjustedY,
      );
    } else {
      ref.read(eyePupilPositionProvider.notifier).state = Offset(
        normalizedX,
        normalizedY,
      );
    }
  }

  void dispose() {
    blinkController.dispose();
    bounceController.dispose();
    floatController.dispose();
    emotionTransitionController.dispose();
    blinkTimer?.cancel();
    emotionTimer?.cancel();
  }
}
