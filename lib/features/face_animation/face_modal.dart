// models/face_expression.dart
import 'package:flutter/material.dart';

// Face Expression Types
enum ExpressionType {
  happy,
  cute,
  angry,
  confused,
  dead,
  sad,
  wink,
  neutral,
  blushing,
  vampire,
  sleepy,
  eyeRoll,
  crying,
  thinking,
  laughing,
  smirk,
  catty,
  love,
  surprised,
  closed,
  glasses,
  worried,
  music,
}

class FaceExpression {
  final ExpressionType type;
  final List<Offset> leftEyePositions;
  final List<Offset> rightEyePositions;
  final List<Offset> leftEyebrowPositions;
  final List<Offset> rightEyebrowPositions;
  final List<Offset> mouthPositions;
  final List<Offset> blushPositions;
  final List<Offset> extraFeaturePositions;
  final bool hasLeftPupil;
  final bool hasRightPupil;
  final double leftPupilScale;
  final double rightPupilScale;
  final Color faceColor;

  // Special animation flags
  final bool tearsDrop;
  final bool hasBlush;
  final bool hasHearts;
  final bool hasGlasses;
  final bool hasFangs;
  final bool hasMusic;
  final bool tongueOut;

  FaceExpression({
    required this.type,
    required this.leftEyePositions,
    required this.rightEyePositions,
    required this.leftEyebrowPositions,
    required this.rightEyebrowPositions,
    required this.mouthPositions,
    this.blushPositions = const [],
    this.extraFeaturePositions = const [],
    this.hasLeftPupil = true,
    this.hasRightPupil = true,
    this.leftPupilScale = 1.0,
    this.rightPupilScale = 1.0,
    this.faceColor = Colors.white,
    this.tearsDrop = false,
    this.hasBlush = false,
    this.hasHearts = false,
    this.hasGlasses = false,
    this.hasFangs = false,
    this.hasMusic = false,
    this.tongueOut = false,
  });

  FaceExpression copyWith({
    ExpressionType? type,
    List<Offset>? leftEyePositions,
    List<Offset>? rightEyePositions,
    List<Offset>? leftEyebrowPositions,
    List<Offset>? rightEyebrowPositions,
    List<Offset>? mouthPositions,
    List<Offset>? blushPositions,
    List<Offset>? extraFeaturePositions,
    bool? hasLeftPupil,
    bool? hasRightPupil,
    double? leftPupilScale,
    double? rightPupilScale,
    Color? faceColor,
    bool? tearsDrop,
    bool? hasBlush,
    bool? hasHearts,
    bool? hasGlasses,
    bool? hasFangs,
    bool? hasMusic,
    bool? tongueOut,
  }) {
    return FaceExpression(
      type: type ?? this.type,
      leftEyePositions: leftEyePositions ?? this.leftEyePositions,
      rightEyePositions: rightEyePositions ?? this.rightEyePositions,
      leftEyebrowPositions: leftEyebrowPositions ?? this.leftEyebrowPositions,
      rightEyebrowPositions:
          rightEyebrowPositions ?? this.rightEyebrowPositions,
      mouthPositions: mouthPositions ?? this.mouthPositions,
      blushPositions: blushPositions ?? this.blushPositions,
      extraFeaturePositions:
          extraFeaturePositions ?? this.extraFeaturePositions,
      hasLeftPupil: hasLeftPupil ?? this.hasLeftPupil,
      hasRightPupil: hasRightPupil ?? this.hasRightPupil,
      leftPupilScale: leftPupilScale ?? this.leftPupilScale,
      rightPupilScale: rightPupilScale ?? this.rightPupilScale,
      faceColor: faceColor ?? this.faceColor,
      tearsDrop: tearsDrop ?? this.tearsDrop,
      hasBlush: hasBlush ?? this.hasBlush,
      hasHearts: hasHearts ?? this.hasHearts,
      hasGlasses: hasGlasses ?? this.hasGlasses,
      hasFangs: hasFangs ?? this.hasFangs,
      hasMusic: hasMusic ?? this.hasMusic,
      tongueOut: tongueOut ?? this.tongueOut,
    );
  }
}
