// utils/expression_factory.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:robot_display_v2/features/face_animation/face_modal.dart';

class ExpressionFactory {
  // Factory method to get expressions
  FaceExpression getExpression(ExpressionType type) {
    switch (type) {
      case ExpressionType.happy:
        return _getHappyExpression();
      case ExpressionType.cute:
        return _getCuteExpression();
      case ExpressionType.angry:
        return _getAngryExpression();
      case ExpressionType.confused:
        return _getConfusedExpression();
      case ExpressionType.dead:
        return _getDeadExpression();
      case ExpressionType.sad:
        return _getSadExpression();
      case ExpressionType.wink:
        return _getWinkExpression();
      case ExpressionType.neutral:
        return getNeutralExpression();
      case ExpressionType.blushing:
        return _getBlushingExpression();
      case ExpressionType.vampire:
        return _getVampireExpression();
      case ExpressionType.sleepy:
        return _getSleepyExpression();
      case ExpressionType.eyeRoll:
        return _getEyeRollExpression();
      case ExpressionType.crying:
        return _getCryingExpression();
      case ExpressionType.thinking:
        return _getThinkingExpression();
      case ExpressionType.laughing:
        return _getLaughingExpression();
      case ExpressionType.smirk:
        return _getSmirkExpression();
      case ExpressionType.catty:
        return _getCattyExpression();
      case ExpressionType.love:
        return _getLoveExpression();
      case ExpressionType.surprised:
        return _getSurprisedExpression();
      case ExpressionType.closed:
        return _getClosedExpression();
      case ExpressionType.glasses:
        return _getGlassesExpression();
      case ExpressionType.worried:
        return _getWorriedExpression();
      case ExpressionType.music:
        return _getMusicExpression();
      default:
        return getNeutralExpression();
    }
  }

  // Default neutral expression
  FaceExpression getNeutralExpression() {
    return FaceExpression(
      type: ExpressionType.neutral,
      leftEyePositions: [Offset(-0.25, 0.0), Offset(-0.1, 0.0)],
      rightEyePositions: [Offset(0.1, 0.0), Offset(0.25, 0.0)],
      leftEyebrowPositions: [Offset(-0.28, -0.15), Offset(-0.1, -0.15)],
      rightEyebrowPositions: [Offset(0.1, -0.15), Offset(0.28, -0.15)],
      mouthPositions: [Offset(-0.15, 0.2), Offset(0.0, 0.2), Offset(0.15, 0.2)],
    );
  }

  // Happy expression with curved up mouth
  FaceExpression _getHappyExpression() {
    return FaceExpression(
      type: ExpressionType.happy,
      leftEyePositions: [Offset(-0.25, 0.0), Offset(-0.1, 0.0)],
      rightEyePositions: [Offset(0.1, 0.0), Offset(0.25, 0.0)],
      leftEyebrowPositions: [Offset(-0.28, -0.17), Offset(-0.1, -0.15)],
      rightEyebrowPositions: [Offset(0.1, -0.15), Offset(0.28, -0.17)],
      mouthPositions: [
        Offset(-0.15, 0.2),
        Offset(0.0, 0.25),
        Offset(0.15, 0.2),
      ],
    );
  }

  // Cute expression with curved eyes and small mouth
  FaceExpression _getCuteExpression() {
    return FaceExpression(
      type: ExpressionType.cute,
      leftEyePositions: [Offset(-0.20, -0.02), Offset(-0.05, 0.02)],
      rightEyePositions: [Offset(0.05, 0.02), Offset(0.20, -0.02)],
      leftEyebrowPositions: [Offset(-0.22, -0.15), Offset(-0.08, -0.13)],
      rightEyebrowPositions: [Offset(0.08, -0.13), Offset(0.22, -0.15)],
      mouthPositions: [
        Offset(-0.05, 0.18),
        Offset(0.0, 0.20),
        Offset(0.05, 0.18),
      ],
      hasBlush: true,
      blushPositions: [Offset(-0.25, 0.10), Offset(0.25, 0.10)],
    );
  }

  // Angry expression with angled eyebrows and frown
  FaceExpression _getAngryExpression() {
    return FaceExpression(
      type: ExpressionType.angry,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.10), Offset(-0.10, -0.20)],
      rightEyebrowPositions: [Offset(0.10, -0.20), Offset(0.25, -0.10)],
      mouthPositions: [
        Offset(-0.15, 0.15),
        Offset(0.0, 0.20),
        Offset(0.15, 0.15),
      ],
    );
  }

  // Confused expression
  FaceExpression _getConfusedExpression() {
    return FaceExpression(
      type: ExpressionType.confused,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.10), Offset(-0.10, -0.15)],
      rightEyebrowPositions: [Offset(0.10, -0.20), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.08, 0.20),
        Offset(0.0, 0.20),
        Offset(0.10, 0.22),
      ],
      extraFeaturePositions: [
        Offset(0.25, 0.1), // For the question mark
      ],
    );
  }

  // Dead expression with X eyes
  FaceExpression _getDeadExpression() {
    return FaceExpression(
      type: ExpressionType.dead,
      leftEyePositions: [
        Offset(-0.20, -0.03),
        Offset(-0.05, 0.03),
        Offset(-0.20, 0.03),
        Offset(-0.05, -0.03),
      ],
      rightEyePositions: [
        Offset(0.05, -0.03),
        Offset(0.20, 0.03),
        Offset(0.05, 0.03),
        Offset(0.20, -0.03),
      ],
      leftEyebrowPositions: [Offset(-0.23, -0.15), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.15)],
      mouthPositions: [
        Offset(-0.10, 0.20),
        Offset(0.0, 0.18),
        Offset(0.10, 0.20),
      ],
      hasLeftPupil: false,
      hasRightPupil: false,
    );
  }

  // Sad expression with downturned mouth
  FaceExpression _getSadExpression() {
    return FaceExpression(
      type: ExpressionType.sad,
      leftEyePositions: [Offset(-0.18, 0.0), Offset(-0.07, 0.0)],
      rightEyePositions: [Offset(0.07, 0.0), Offset(0.18, 0.0)],
      leftEyebrowPositions: [Offset(-0.23, -0.17), Offset(-0.08, -0.12)],
      rightEyebrowPositions: [Offset(0.08, -0.12), Offset(0.23, -0.17)],
      mouthPositions: [
        Offset(-0.15, 0.18),
        Offset(0.0, 0.15),
        Offset(0.15, 0.18),
      ],
    );
  }

  // Wink expression
  FaceExpression _getWinkExpression() {
    return FaceExpression(
      type: ExpressionType.wink,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, -0.02), Offset(0.20, 0.02)],
      leftEyebrowPositions: [Offset(-0.25, -0.15), Offset(-0.05, -0.15)],
      rightEyebrowPositions: [Offset(0.05, -0.13), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.15, 0.20),
        Offset(0.0, 0.23),
        Offset(0.15, 0.20),
      ],
      hasRightPupil: false,
    );
  }

  // Blushing expression
  FaceExpression _getBlushingExpression() {
    return FaceExpression(
      type: ExpressionType.blushing,
      leftEyePositions: [Offset(-0.18, 0.0), Offset(-0.07, 0.0)],
      rightEyePositions: [Offset(0.07, 0.0), Offset(0.18, 0.0)],
      leftEyebrowPositions: [Offset(-0.23, -0.15), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.15)],
      mouthPositions: [
        Offset(-0.10, 0.20),
        Offset(0.0, 0.20),
        Offset(0.10, 0.20),
      ],
      hasBlush: true,
      blushPositions: [Offset(-0.25, 0.10), Offset(0.25, 0.10)],
    );
  }

  // Vampire expression with fangs
  FaceExpression _getVampireExpression() {
    return FaceExpression(
      type: ExpressionType.vampire,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.10), Offset(-0.10, -0.15)],
      rightEyebrowPositions: [Offset(0.10, -0.15), Offset(0.25, -0.10)],
      mouthPositions: [
        Offset(-0.15, 0.20),
        Offset(-0.08, 0.22),
        Offset(0.0, 0.20),
        Offset(0.08, 0.22),
        Offset(0.15, 0.20),
      ],
      hasFangs: true,
    );
  }

  // Sleepy expression
  FaceExpression _getSleepyExpression() {
    return FaceExpression(
      type: ExpressionType.sleepy,
      // Curved closed eye positions - more curvy and aligned
      leftEyePositions: [Offset(-0.25, 0.0), Offset(-0.1, 0.0)],
      rightEyePositions: [Offset(0.1, 0.0), Offset(0.25, 0.0)],
      // Align eyebrows with eyes for cute look
      leftEyebrowPositions: [Offset(-0.28, -0.12), Offset(-0.08, -0.12)],
      rightEyebrowPositions: [Offset(0.08, -0.12), Offset(0.28, -0.12)],
      // Circular small mouth
      mouthPositions: [
        Offset(0.0, 0.2), // Center point for circular mouth
      ],
      // Repositioned Z characters to not overlap with eyes
      extraFeaturePositions: [
        Offset(0.35, -0.15), // Main Z position - moved further right
        Offset(0.28, -0.07), // Medium Z position
        Offset(0.21, 0.0), // Smallest Z position
      ],
      // Set no pupils for closed eyes
      hasLeftPupil: false,
      hasRightPupil: false,
    );
  }

  // Eye roll expression
  FaceExpression _getEyeRollExpression() {
    return FaceExpression(
      type: ExpressionType.eyeRoll,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.15), Offset(-0.05, -0.12)],
      rightEyebrowPositions: [Offset(0.05, -0.12), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.12, 0.20),
        Offset(0.0, 0.20),
        Offset(0.12, 0.20),
      ],
      leftPupilScale: 0.8,
      rightPupilScale: 0.8,
      extraFeaturePositions: [
        Offset(-0.12, -0.05), // Left pupil position
        Offset(0.12, -0.05), // Right pupil position
      ],
    );
  }

  // Crying expression
  FaceExpression _getCryingExpression() {
    return FaceExpression(
      type: ExpressionType.crying,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.18), Offset(-0.10, -0.12)],
      rightEyebrowPositions: [Offset(0.10, -0.12), Offset(0.25, -0.18)],
      mouthPositions: [
        Offset(-0.15, 0.18),
        Offset(0.0, 0.15),
        Offset(0.15, 0.18),
      ],
      tearsDrop: true,
      extraFeaturePositions: [
        Offset(-0.15, 0.05), // Tear position
        Offset(0.15, 0.05), // Tear position
      ],
    );
  }

  // Thinking expression
  FaceExpression _getThinkingExpression() {
    return FaceExpression(
      type: ExpressionType.thinking,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, -0.02), Offset(0.20, 0.02)],
      leftEyebrowPositions: [Offset(-0.25, -0.15), Offset(-0.05, -0.15)],
      rightEyebrowPositions: [Offset(0.05, -0.10), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.05, 0.20),
        Offset(0.0, 0.20),
        Offset(0.10, 0.20),
      ],
      extraFeaturePositions: [
        Offset(0.30, -0.10), // Thought bubble
      ],
    );
  }

  // Laughing expression
  FaceExpression _getLaughingExpression() {
    return FaceExpression(
      type: ExpressionType.laughing,
      leftEyePositions: [Offset(-0.18, -0.02), Offset(-0.07, 0.02)],
      rightEyePositions: [Offset(0.07, 0.02), Offset(0.18, -0.02)],
      leftEyebrowPositions: [Offset(-0.23, -0.18), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.18)],
      mouthPositions: [
        Offset(-0.18, 0.18),
        Offset(-0.09, 0.23),
        Offset(0.0, 0.18),
        Offset(0.09, 0.23),
        Offset(0.18, 0.18),
      ],
    );
  }

  // Smirk expression
  FaceExpression _getSmirkExpression() {
    return FaceExpression(
      type: ExpressionType.smirk,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, -0.02), Offset(0.20, 0.02)],
      leftEyebrowPositions: [Offset(-0.25, -0.15), Offset(-0.05, -0.15)],
      rightEyebrowPositions: [Offset(0.05, -0.13), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.15, 0.18),
        Offset(0.0, 0.20),
        Offset(0.15, 0.25),
      ],
    );
  }

  // Catty expression
  FaceExpression _getCattyExpression() {
    return FaceExpression(
      type: ExpressionType.catty,
      leftEyePositions: [Offset(-0.18, -0.02), Offset(-0.07, 0.02)],
      rightEyePositions: [Offset(0.07, 0.02), Offset(0.18, -0.02)],
      leftEyebrowPositions: [Offset(-0.23, -0.15), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.15)],
      mouthPositions: [
        Offset(-0.05, 0.15),
        Offset(0.0, 0.18),
        Offset(0.05, 0.15),
      ],
      extraFeaturePositions: [
        Offset(-0.22, -0.25), // Left cat ear
        Offset(0.22, -0.25), // Right cat ear
        Offset(0.0, 0.25), // Whiskers center point
      ],
    );
  }

  // Love expression with heart eyes
  FaceExpression _getLoveExpression() {
    return FaceExpression(
      type: ExpressionType.love,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.23, -0.15), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.15)],
      mouthPositions: [
        Offset(-0.10, 0.20),
        Offset(0.0, 0.23),
        Offset(0.10, 0.20),
      ],
      hasLeftPupil: false,
      hasRightPupil: false,
      hasHearts: true,
      extraFeaturePositions: [
        Offset(-0.12, 0.0), // Left heart position
        Offset(0.12, 0.0), // Right heart position
      ],
    );
  }

  // Surprised expression
  FaceExpression _getSurprisedExpression() {
    return FaceExpression(
      type: ExpressionType.surprised,
      leftEyePositions: [Offset(-0.18, 0.0), Offset(-0.07, 0.0)],
      rightEyePositions: [Offset(0.07, 0.0), Offset(0.18, 0.0)],
      leftEyebrowPositions: [Offset(-0.23, -0.20), Offset(-0.07, -0.20)],
      rightEyebrowPositions: [Offset(0.07, -0.20), Offset(0.23, -0.20)],
      mouthPositions: [Offset(0.0, 0.20), Offset(0.0, 0.20), Offset(0.0, 0.20)],
      extraFeaturePositions: [
        Offset(0.0, 0.20), // Center of O-shaped mouth
      ],
    );
  }

  // Closed eyes expression
  FaceExpression _getClosedExpression() {
    return FaceExpression(
      type: ExpressionType.closed,
      leftEyePositions: [Offset(-0.18, -0.02), Offset(-0.07, 0.02)],
      rightEyePositions: [Offset(0.07, 0.02), Offset(0.18, -0.02)],
      leftEyebrowPositions: [Offset(-0.23, -0.15), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.15)],
      mouthPositions: [
        Offset(-0.10, 0.20),
        Offset(0.0, 0.22),
        Offset(0.10, 0.20),
      ],
      hasLeftPupil: false,
      hasRightPupil: false,
    );
  }

  // Glasses expression
  FaceExpression _getGlassesExpression() {
    return FaceExpression(
      type: ExpressionType.glasses,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.25, -0.15), Offset(-0.05, -0.15)],
      rightEyebrowPositions: [Offset(0.05, -0.15), Offset(0.25, -0.15)],
      mouthPositions: [
        Offset(-0.15, 0.20),
        Offset(0.0, 0.20),
        Offset(0.15, 0.20),
      ],
      hasGlasses: true,
    );
  }

  // Worried expression
  FaceExpression _getWorriedExpression() {
    return FaceExpression(
      type: ExpressionType.worried,
      leftEyePositions: [Offset(-0.20, 0.0), Offset(-0.05, 0.0)],
      rightEyePositions: [Offset(0.05, 0.0), Offset(0.20, 0.0)],
      leftEyebrowPositions: [Offset(-0.23, -0.18), Offset(-0.08, -0.12)],
      rightEyebrowPositions: [Offset(0.08, -0.12), Offset(0.23, -0.18)],
      mouthPositions: [
        Offset(-0.10, 0.20),
        Offset(0.0, 0.18),
        Offset(0.10, 0.20),
      ],
    );
  }

  // Music expression
  FaceExpression _getMusicExpression() {
    return FaceExpression(
      type: ExpressionType.music,
      leftEyePositions: [Offset(-0.18, -0.02), Offset(-0.07, 0.02)],
      rightEyePositions: [Offset(0.07, 0.02), Offset(0.18, -0.02)],
      leftEyebrowPositions: [Offset(-0.23, -0.17), Offset(-0.07, -0.15)],
      rightEyebrowPositions: [Offset(0.07, -0.15), Offset(0.23, -0.17)],
      mouthPositions: [
        Offset(-0.15, 0.20),
        Offset(0.0, 0.23),
        Offset(0.15, 0.20),
      ],
      hasMusic: true,
      extraFeaturePositions: [
        Offset(0.28, -0.10), // Music note position
      ],
    );
  }
}
