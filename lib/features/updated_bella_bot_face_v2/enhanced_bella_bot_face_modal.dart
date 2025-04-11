// lib/models/face_expression.dart
import 'package:flutter/material.dart';

// Face Expression Types with expanded options
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
  excited,
  scared,
  laughing,
  listening,
  processing,
  crying,
}

// Theme options for the robot
enum RobotTheme {
  default_theme,
  night,
  ocean,
  sunset,
  neon,
  pastel,
  alien,
  cyborg,
}

// Accessory types
enum AccessoryType {
  none,
  glasses,
  hat,
  bowtie,
  headphones,
  crown,
  flower,
  antenna,
  bandana,
}

// Character skin types
enum CharacterSkin { robot, cat, dog, alien, panda, underwater, space }

class BellaBotExpression {
  final ExpressionType type;
  final double leftEyeOpenness;
  final double rightEyeOpenness;
  final Offset leftEyebrowOffset;
  final Offset rightEyebrowOffset;
  final double mouthCurvature;
  final bool hasBlush;
  final Color faceColor;

  // Enhanced properties
  final String? thoughtBubbleText;
  final String? speechBubbleText;
  final List<Color> eyeColors; // Can be gradient or single color
  final Color glowColor;
  final double glowIntensity;
  final List<String> emotionEmojis;
  final List<ParticleEffect> particleEffects;
  final bool isAnimatedEffect;
  final AccessoryType accessory;

  BellaBotExpression({
    required this.type,
    this.leftEyeOpenness = 1.0,
    this.rightEyeOpenness = 1.0,
    this.leftEyebrowOffset = Offset.zero,
    this.rightEyebrowOffset = Offset.zero,
    this.mouthCurvature = 0.0,
    this.hasBlush = false,
    this.faceColor = Colors.white,
    this.thoughtBubbleText,
    this.speechBubbleText,
    this.eyeColors = const [Colors.black],
    this.glowColor = Colors.transparent,
    this.glowIntensity = 0.0,
    this.emotionEmojis = const [],
    this.particleEffects = const [],
    this.isAnimatedEffect = false,
    this.accessory = AccessoryType.none,
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
    String? thoughtBubbleText,
    String? speechBubbleText,
    List<Color>? eyeColors,
    Color? glowColor,
    double? glowIntensity,
    List<String>? emotionEmojis,
    List<ParticleEffect>? particleEffects,
    bool? isAnimatedEffect,
    AccessoryType? accessory,
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
      thoughtBubbleText: thoughtBubbleText ?? this.thoughtBubbleText,
      speechBubbleText: speechBubbleText ?? this.speechBubbleText,
      eyeColors: eyeColors ?? this.eyeColors,
      glowColor: glowColor ?? this.glowColor,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      emotionEmojis: emotionEmojis ?? this.emotionEmojis,
      particleEffects: particleEffects ?? this.particleEffects,
      isAnimatedEffect: isAnimatedEffect ?? this.isAnimatedEffect,
      accessory: accessory ?? this.accessory,
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

// Theme data class
class RobotThemeData {
  final Color primaryColor;
  final Color backgroundColor;
  final Color accentColor;
  final List<Color> backgroundGradient;
  final Color eyeColor;
  final Color glowColor;
  final String themeName;
  final bool hasDarkMode;

  const RobotThemeData({
    required this.primaryColor,
    required this.backgroundColor,
    required this.accentColor,
    required this.backgroundGradient,
    required this.eyeColor,
    required this.glowColor,
    required this.themeName,
    this.hasDarkMode = false,
  });
}

// Audio visualization data
class AudioVisualData {
  final List<double> amplitudes;
  final bool isActive;
  final double mainFrequency;

  const AudioVisualData({
    this.amplitudes = const [],
    this.isActive = false,
    this.mainFrequency = 0.0,
  });
}

// Particle effects
class ParticleEffect {
  final ParticleType type;
  final Color color;
  final int count;
  final double size;
  final double speed;

  const ParticleEffect({
    required this.type,
    required this.color,
    this.count = 10,
    this.size = 5.0,
    this.speed = 1.0,
  });
}

enum ParticleType {
  bubble,
  sparkle,
  raindrop,
  heart,
  star,
  lightning,
  snowflake,
  confetti,
}
