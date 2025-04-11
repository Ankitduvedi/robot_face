// lib/utils/expression_factory.dart
import 'package:flutter/material.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';

class ExpressionFactory {
  // Factory method to get expressions
  BellaBotExpression getExpression(ExpressionType type) {
    switch (type) {
      case ExpressionType.happy:
        return _getHappyExpression();
      case ExpressionType.sad:
        return _getSadExpression();
      case ExpressionType.angry:
        return _getAngryExpression();
      case ExpressionType.surprised:
        return _getSurprisedExpression();
      case ExpressionType.wink:
        return _getWinkExpression();
      case ExpressionType.blushing:
        return _getBlushingExpression();
      case ExpressionType.sleepy:
        return _getSleepyExpression();
      case ExpressionType.thinking:
        return _getThinkingExpression();
      case ExpressionType.loving:
        return _getLovingExpression();
      case ExpressionType.confused:
        return _getConfusedExpression();
      case ExpressionType.neutral:
      default:
        return getNeutralExpression();
    }
  }

  // Default neutral expression
  BellaBotExpression getNeutralExpression() {
    return BellaBotExpression(
      type: ExpressionType.neutral,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 1.0,
      leftEyebrowOffset: Offset.zero,
      rightEyebrowOffset: Offset.zero,
      mouthCurvature: 0.0,
    );
  }

  // Happy expression
  BellaBotExpression _getHappyExpression() {
    return BellaBotExpression(
      type: ExpressionType.happy,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: const Offset(0, -5.0),
      rightEyebrowOffset: const Offset(0, -5.0),
      mouthCurvature: 0.5, // Curved up
    );
  }

  // Sad expression
  BellaBotExpression _getSadExpression() {
    return BellaBotExpression(
      type: ExpressionType.sad,
      leftEyeOpenness: 0.7,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-2.0, 2.0),
      rightEyebrowOffset: const Offset(2.0, 2.0),
      mouthCurvature: -0.5, // Curved down
    );
  }

  // Angry expression
  BellaBotExpression _getAngryExpression() {
    return BellaBotExpression(
      type: ExpressionType.angry,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: const Offset(-5.0, -5.0),
      rightEyebrowOffset: const Offset(5.0, -5.0),
      mouthCurvature: -0.3,
    );
  }

  // Surprised expression
  BellaBotExpression _getSurprisedExpression() {
    return BellaBotExpression(
      type: ExpressionType.surprised,
      leftEyeOpenness: 1.3, // Eyes wide open
      rightEyeOpenness: 1.3,
      leftEyebrowOffset: const Offset(0, -8.0),
      rightEyebrowOffset: const Offset(0, -8.0),
      mouthCurvature: 0.0, // O-shaped mouth
    );
  }

  // Wink expression
  BellaBotExpression _getWinkExpression() {
    return BellaBotExpression(
      type: ExpressionType.wink,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 0.1, // Right eye almost closed
      leftEyebrowOffset: const Offset(0, -2.0),
      rightEyebrowOffset: const Offset(0, 2.0),
      mouthCurvature: 0.3,
    );
  }

  // Blushing expression
  BellaBotExpression _getBlushingExpression() {
    return BellaBotExpression(
      type: ExpressionType.blushing,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: Offset.zero,
      rightEyebrowOffset: Offset.zero,
      mouthCurvature: 0.2,
      hasBlush: true,
    );
  }

  // Sleepy expression
  BellaBotExpression _getSleepyExpression() {
    return BellaBotExpression(
      type: ExpressionType.sleepy,
      leftEyeOpenness: 0.4, // Half-closed eyes
      rightEyeOpenness: 0.4,
      leftEyebrowOffset: const Offset(0, 2.0),
      rightEyebrowOffset: const Offset(0, 2.0),
      mouthCurvature: -0.1,
    );
  }

  // Thinking expression
  BellaBotExpression _getThinkingExpression() {
    return BellaBotExpression(
      type: ExpressionType.thinking,
      leftEyeOpenness: 0.9,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-2.0, -3.0),
      rightEyebrowOffset: const Offset(5.0, -6.0),
      mouthCurvature: 0.1,
    );
  }

  // Loving expression
  BellaBotExpression _getLovingExpression() {
    return BellaBotExpression(
      type: ExpressionType.loving,
      leftEyeOpenness: 0.6,
      rightEyeOpenness: 0.6,
      leftEyebrowOffset: const Offset(0, -2.0),
      rightEyebrowOffset: const Offset(0, -2.0),
      mouthCurvature: 0.4,
      hasBlush: true,
    );
  }

  // Confused expression
  BellaBotExpression _getConfusedExpression() {
    return BellaBotExpression(
      type: ExpressionType.confused,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-3.0, -5.0),
      rightEyebrowOffset: const Offset(3.0, 0),
      mouthCurvature: 0.0,
    );
  }
}
