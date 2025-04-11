// lib/models/face_expression.dart
import 'package:flutter/material.dart';

// Face Expression Types
enum ExpressionType {
  happy,
  sad,
  angry,
  surprised,
  wink,
  neutral,
  blushing,
  sleepy,
  thinking,
  loving,
  confused,
}

class BellaBotExpression {
  final ExpressionType type;
  final double leftEyeOpenness;
  final double rightEyeOpenness;
  final Offset leftEyebrowOffset;
  final Offset rightEyebrowOffset;
  final double mouthCurvature;
  final bool hasBlush;
  final Color faceColor;

  BellaBotExpression({
    required this.type,
    this.leftEyeOpenness = 1.0,
    this.rightEyeOpenness = 1.0,
    this.leftEyebrowOffset = Offset.zero,
    this.rightEyebrowOffset = Offset.zero,
    this.mouthCurvature = 0.0,
    this.hasBlush = false,
    this.faceColor = Colors.white,
  });

  BellaBotExpression copyWith({
    ExpressionType? type,
    double? leftEyeOpenness,
    double? rightEyeOpenness,
    Offset? leftEyebrowOffset,
    Offset? rightEyebrowOffset,
    double? mouthCurvature,
    bool? hasBlush,
    Color? faceColor,
  }) {
    return BellaBotExpression(
      type: type ?? this.type,
      leftEyeOpenness: leftEyeOpenness ?? this.leftEyeOpenness,
      rightEyeOpenness: rightEyeOpenness ?? this.rightEyeOpenness,
      leftEyebrowOffset: leftEyebrowOffset ?? this.leftEyebrowOffset,
      rightEyebrowOffset: rightEyebrowOffset ?? this.rightEyebrowOffset,
      mouthCurvature: mouthCurvature ?? this.mouthCurvature,
      hasBlush: hasBlush ?? this.hasBlush,
      faceColor: faceColor ?? this.faceColor,
    );
  }
}

// Face coordinates for tracking
class FaceCoordinate {
  final double x;
  final double y;
  final double width;
  final double height;

  FaceCoordinate({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}
