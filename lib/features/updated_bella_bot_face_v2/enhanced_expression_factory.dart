// lib/utils/expression_factory.dart
import 'package:flutter/material.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';

class ExpressionFactory {
  // Current theme to apply to expressions
  RobotTheme _currentTheme = RobotTheme.default_theme;
  CharacterSkin _currentSkin = CharacterSkin.robot;
  AccessoryType _currentAccessory = AccessoryType.none;

  // Theme getters and setters
  RobotTheme get currentTheme => _currentTheme;
  CharacterSkin get currentSkin => _currentSkin;
  AccessoryType get currentAccessory => _currentAccessory;

  set currentTheme(RobotTheme theme) {
    _currentTheme = theme;
  }

  set currentSkin(CharacterSkin skin) {
    _currentSkin = skin;
  }

  set currentAccessory(AccessoryType accessory) {
    _currentAccessory = accessory;
  }

  // Get theme data
  RobotThemeData getThemeData(RobotTheme theme) {
    switch (theme) {
      case RobotTheme.night:
        return const RobotThemeData(
          primaryColor: Color(0xFF2C3E50),
          backgroundColor: Color(0xFF1A1A2E),
          accentColor: Color(0xFF3498DB),
          backgroundGradient: [Color(0xFF0F0F1B), Color(0xFF2C3E50)],
          eyeColor: Color(0xFF3498DB),
          glowColor: Color(0xFF3498DB),
          themeName: 'Night Mode',
          hasDarkMode: true,
        );
      case RobotTheme.ocean:
        return const RobotThemeData(
          primaryColor: Color(0xFF1E88E5),
          backgroundColor: Color(0xFF0D47A1),
          accentColor: Color(0xFF4FC3F7),
          backgroundGradient: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
          eyeColor: Color(0xFF4FC3F7),
          glowColor: Color(0xFF4FC3F7),
          themeName: 'Ocean',
          hasDarkMode: false,
        );
      case RobotTheme.sunset:
        return const RobotThemeData(
          primaryColor: Color(0xFFFF7043),
          backgroundColor: Color(0xFFE64A19),
          accentColor: Color(0xFFFFD54F),
          backgroundGradient: [Color(0xFFE64A19), Color(0xFF7B1FA2)],
          eyeColor: Color(0xFFFFD54F),
          glowColor: Color(0xFFFF7043),
          themeName: 'Sunset',
          hasDarkMode: false,
        );
      case RobotTheme.neon:
        return const RobotThemeData(
          primaryColor: Color(0xFF00E676),
          backgroundColor: Color(0xFF212121),
          accentColor: Color(0xFFFF80AB),
          backgroundGradient: [Color(0xFF212121), Color(0xFF424242)],
          eyeColor: Color(0xFF00E676),
          glowColor: Color(0xFF00E676),
          themeName: 'Neon',
          hasDarkMode: true,
        );
      case RobotTheme.pastel:
        return const RobotThemeData(
          primaryColor: Color(0xFFFFCCBC),
          backgroundColor: Color(0xFFF8BBD0),
          accentColor: Color(0xFFB2EBF2),
          backgroundGradient: [Color(0xFFF8BBD0), Color(0xFFC5CAE9)],
          eyeColor: Color(0xFF90CAF9),
          glowColor: Color(0xFFFFCCBC),
          themeName: 'Pastel',
          hasDarkMode: false,
        );
      case RobotTheme.alien:
        return const RobotThemeData(
          primaryColor: Color(0xFF76FF03),
          backgroundColor: Color(0xFF311B92),
          accentColor: Color(0xFFB388FF),
          backgroundGradient: [Color(0xFF311B92), Color(0xFF1B5E20)],
          eyeColor: Color(0xFFFFEA00),
          glowColor: Color(0xFF76FF03),
          themeName: 'Alien',
          hasDarkMode: true,
        );
      case RobotTheme.cyborg:
        return const RobotThemeData(
          primaryColor: Color(0xFFBDBDBD),
          backgroundColor: Color(0xFF212121),
          accentColor: Color(0xFFEF5350),
          backgroundGradient: [Color(0xFF212121), Color(0xFF263238)],
          eyeColor: Color(0xFFEF5350),
          glowColor: Color(0xFFEF5350),
          themeName: 'Cyborg',
          hasDarkMode: true,
        );
      case RobotTheme.default_theme:
      default:
        return const RobotThemeData(
          primaryColor: Colors.white,
          backgroundColor: Color(0xFF303030),
          accentColor: Color(0xFF2196F3),
          backgroundGradient: [Color(0xFF303030), Color(0xFF424242)],
          eyeColor: Colors.black,
          glowColor: Color(0xFF2196F3),
          themeName: 'Default',
          hasDarkMode: true,
        );
    }
  }

  // Factory method to get expressions with theme applied
  BellaBotExpression getExpression(ExpressionType type) {
    // Get base expression
    BellaBotExpression expression;

    switch (type) {
      case ExpressionType.happy:
        expression = _getHappyExpression();
        break;
      case ExpressionType.sad:
        expression = _getSadExpression();
        break;
      case ExpressionType.angry:
        expression = _getAngryExpression();
        break;
      case ExpressionType.surprised:
        expression = _getSurprisedExpression();
        break;
      case ExpressionType.wink:
        expression = _getWinkExpression();
        break;
      case ExpressionType.blushing:
        expression = _getBlushingExpression();
        break;
      case ExpressionType.sleepy:
        expression = _getSleepyExpression();
        break;
      case ExpressionType.thinking:
        expression = _getThinkingExpression();
        break;
      case ExpressionType.loving:
        expression = _getLovingExpression();
        break;
      case ExpressionType.confused:
        expression = _getConfusedExpression();
        break;
      case ExpressionType.excited:
        expression = _getExcitedExpression();
        break;
      case ExpressionType.scared:
        expression = _getScaredExpression();
        break;
      case ExpressionType.laughing:
        expression = _getLaughingExpression();
        break;
      case ExpressionType.listening:
        expression = _getListeningExpression();
        break;
      case ExpressionType.processing:
        expression = _getProcessingExpression();
        break;
      case ExpressionType.neutral:
      default:
        expression = getNeutralExpression();
    }

    // Apply current theme
    final themeData = getThemeData(_currentTheme);

    // Apply skin modifications if needed
    expression = _applySkinToExpression(expression, _currentSkin);

    // Apply accessory
    expression = expression.copyWith(
      accessory: _currentAccessory,
      eyeColors: [themeData.eyeColor],
      glowColor: themeData.glowColor,
      glowIntensity: _getGlowIntensityForExpression(type),
      faceColor: _getSkinColor(_currentSkin, themeData.primaryColor),
    );

    return expression;
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
      speechBubbleText: "Hello!",
    );
  }

  // Happy expression with enhanced features
  BellaBotExpression _getHappyExpression() {
    return BellaBotExpression(
      type: ExpressionType.happy,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: const Offset(0, -5.0),
      rightEyebrowOffset: const Offset(0, -5.0),
      mouthCurvature: 0.5, // Curved up
      glowIntensity: 0.7,
      speechBubbleText: "I'm happy!",
      emotionEmojis: ["😊", "😄", "🌟"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.sparkle,
          color: Colors.yellow,
          count: 15,
        ),
        ParticleEffect(
          type: ParticleType.confetti,
          color: Colors.orange,
          count: 10,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Sad expression with enhanced features
  BellaBotExpression _getSadExpression() {
    return BellaBotExpression(
      type: ExpressionType.sad,
      leftEyeOpenness: 0.7,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-2.0, 2.0),
      rightEyebrowOffset: const Offset(2.0, 2.0),
      mouthCurvature: -0.5, // Curved down
      glowIntensity: 0.3,
      speechBubbleText: "I'm sad...",
      thoughtBubbleText: "Why am I so sad?",
      emotionEmojis: ["😢", "😔", "💧"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.raindrop,
          color: Colors.blue.shade300,
          count: 8,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Angry expression with enhanced features
  BellaBotExpression _getAngryExpression() {
    return BellaBotExpression(
      type: ExpressionType.angry,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: const Offset(-5.0, -5.0),
      rightEyebrowOffset: const Offset(5.0, -5.0),
      mouthCurvature: -0.3,
      glowIntensity: 0.8,
      speechBubbleText: "Grrr!",
      emotionEmojis: ["😠", "💢", "⚡"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.lightning,
          color: Colors.redAccent,
          count: 5,
          speed: 1.5,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Surprised expression with enhanced features
  BellaBotExpression _getSurprisedExpression() {
    return BellaBotExpression(
      type: ExpressionType.surprised,
      leftEyeOpenness: 1.3, // Eyes wide open
      rightEyeOpenness: 1.3,
      leftEyebrowOffset: const Offset(0, -8.0),
      rightEyebrowOffset: const Offset(0, -8.0),
      mouthCurvature: 0.0, // O-shaped mouth
      glowIntensity: 0.6,
      speechBubbleText: "Oh!",
      emotionEmojis: ["😲", "⭐", "❗"],
      particleEffects: [
        ParticleEffect(type: ParticleType.star, color: Colors.amber, count: 8),
      ],
      isAnimatedEffect: true,
    );
  }

  // Wink expression with enhanced features
  BellaBotExpression _getWinkExpression() {
    return BellaBotExpression(
      type: ExpressionType.wink,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 0.1, // Right eye almost closed
      leftEyebrowOffset: const Offset(0, -2.0),
      rightEyebrowOffset: const Offset(0, 2.0),
      mouthCurvature: 0.3,
      glowIntensity: 0.5,
      speechBubbleText: "Just between us...",
      emotionEmojis: ["😉", "✨"],
      isAnimatedEffect: false,
    );
  }

  // Blushing expression with enhanced features
  BellaBotExpression _getBlushingExpression() {
    return BellaBotExpression(
      type: ExpressionType.blushing,
      leftEyeOpenness: 0.8,
      rightEyeOpenness: 0.8,
      leftEyebrowOffset: Offset.zero,
      rightEyebrowOffset: Offset.zero,
      mouthCurvature: 0.2,
      hasBlush: true,
      glowIntensity: 0.4,
      speechBubbleText: "Oh my...",
      emotionEmojis: ["😊", "💕"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.heart,
          color: Colors.pink.shade200,
          count: 5,
          size: 10.0,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Sleepy expression with enhanced features
  BellaBotExpression _getSleepyExpression() {
    return BellaBotExpression(
      type: ExpressionType.sleepy,
      leftEyeOpenness: 0.4, // Half-closed eyes
      rightEyeOpenness: 0.4,
      leftEyebrowOffset: const Offset(0, 2.0),
      rightEyebrowOffset: const Offset(0, 2.0),
      mouthCurvature: -0.1,
      glowIntensity: 0.2,
      thoughtBubbleText: "Zzz...",
      emotionEmojis: ["😴", "💤"],
      isAnimatedEffect: false,
    );
  }

  // Thinking expression with enhanced features
  BellaBotExpression _getThinkingExpression() {
    return BellaBotExpression(
      type: ExpressionType.thinking,
      leftEyeOpenness: 0.9,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-2.0, -3.0),
      rightEyebrowOffset: const Offset(5.0, -6.0),
      mouthCurvature: 0.1,
      glowIntensity: 0.5,
      thoughtBubbleText: "Hmm...",
      emotionEmojis: ["🤔", "💭"],
      isAnimatedEffect: false,
    );
  }

  // Loving expression with enhanced features
  BellaBotExpression _getLovingExpression() {
    return BellaBotExpression(
      type: ExpressionType.loving,
      leftEyeOpenness: 0.6,
      rightEyeOpenness: 0.6,
      leftEyebrowOffset: const Offset(0, -2.0),
      rightEyebrowOffset: const Offset(0, -2.0),
      mouthCurvature: 0.4,
      hasBlush: true,
      glowIntensity: 0.7,
      speechBubbleText: "I like you!",
      emotionEmojis: ["❤️", "😍", "💖"],
      particleEffects: [
        ParticleEffect(type: ParticleType.heart, color: Colors.red, count: 12),
      ],
      isAnimatedEffect: true,
    );
  }

  // Confused expression with enhanced features
  BellaBotExpression _getConfusedExpression() {
    return BellaBotExpression(
      type: ExpressionType.confused,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 0.7,
      leftEyebrowOffset: const Offset(-3.0, -5.0),
      rightEyebrowOffset: const Offset(3.0, 0),
      mouthCurvature: 0.0,
      glowIntensity: 0.4,
      thoughtBubbleText: "I'm not sure I understand...",
      emotionEmojis: ["❓", "🤨"],
      isAnimatedEffect: false,
    );
  }

  // New expressions

  // Excited expression
  BellaBotExpression _getExcitedExpression() {
    return BellaBotExpression(
      type: ExpressionType.excited,
      leftEyeOpenness: 1.2,
      rightEyeOpenness: 1.2,
      leftEyebrowOffset: const Offset(0, -7.0),
      rightEyebrowOffset: const Offset(0, -7.0),
      mouthCurvature: 0.7, // Big smile
      glowIntensity: 0.9,
      speechBubbleText: "WOW!!!",
      emotionEmojis: ["🎉", "🤩", "✨"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.sparkle,
          color: Colors.yellow,
          count: 20,
          speed: 2.0,
        ),
        ParticleEffect(
          type: ParticleType.confetti,
          color: Colors.purple,
          count: 15,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Scared expression
  BellaBotExpression _getScaredExpression() {
    return BellaBotExpression(
      type: ExpressionType.scared,
      leftEyeOpenness: 1.3,
      rightEyeOpenness: 1.3,
      leftEyebrowOffset: const Offset(-2.0, -8.0),
      rightEyebrowOffset: const Offset(2.0, -8.0),
      mouthCurvature: -0.3,
      glowIntensity: 0.6,
      speechBubbleText: "Eek!",
      emotionEmojis: ["😱", "🙀", "💫"],
      isAnimatedEffect: true,
    );
  }

  // Laughing expression
  BellaBotExpression _getLaughingExpression() {
    return BellaBotExpression(
      type: ExpressionType.laughing,
      leftEyeOpenness: 0.3, // Squinting from laughter
      rightEyeOpenness: 0.3,
      leftEyebrowOffset: const Offset(0, -3.0),
      rightEyebrowOffset: const Offset(0, -3.0),
      mouthCurvature: 0.8, // Wide open laughing mouth
      glowIntensity: 0.7,
      speechBubbleText: "Hahaha!",
      emotionEmojis: ["😂", "🤣", "😆"],
      particleEffects: [
        ParticleEffect(
          type: ParticleType.sparkle,
          color: Colors.amber,
          count: 8,
        ),
      ],
      isAnimatedEffect: true,
    );
  }

  // Listening expression
  BellaBotExpression _getListeningExpression() {
    return BellaBotExpression(
      type: ExpressionType.listening,
      leftEyeOpenness: 1.0,
      rightEyeOpenness: 1.0,
      leftEyebrowOffset: const Offset(0, -2.0),
      rightEyebrowOffset: const Offset(0, -2.0),
      mouthCurvature: 0.1,
      glowIntensity: 0.5,
      emotionEmojis: ["👂", "🎧"],
      isAnimatedEffect: true,
    );
  }

  // Processing expression
  BellaBotExpression _getProcessingExpression() {
    return BellaBotExpression(
      type: ExpressionType.processing,
      leftEyeOpenness: 0.9,
      rightEyeOpenness: 0.9,
      leftEyebrowOffset: const Offset(0, -4.0),
      rightEyebrowOffset: const Offset(0, -4.0),
      mouthCurvature: 0.0,
      glowIntensity: 0.8,
      thoughtBubbleText: "Processing...",
      emotionEmojis: ["⚙️", "💭", "🔄"],
      isAnimatedEffect: true,
    );
  }

  // Helper methods
  double _getGlowIntensityForExpression(ExpressionType type) {
    // Emotional expressions have stronger glow
    switch (type) {
      case ExpressionType.excited:
      case ExpressionType.happy:
      case ExpressionType.loving:
      case ExpressionType.angry:
        return 0.8;
      case ExpressionType.surprised:
      case ExpressionType.scared:
      case ExpressionType.laughing:
        return 0.7;
      case ExpressionType.blushing:
      case ExpressionType.wink:
      case ExpressionType.thinking:
      case ExpressionType.confused:
        return 0.5;
      case ExpressionType.sleepy:
      case ExpressionType.sad:
        return 0.3;
      default:
        return 0.4;
    }
  }

  // Apply skin modifications to expression
  BellaBotExpression _applySkinToExpression(
    BellaBotExpression expression,
    CharacterSkin skin,
  ) {
    switch (skin) {
      case CharacterSkin.cat:
        // Adjust eyebrows and add whiskers
        return expression.copyWith(
          leftEyebrowOffset:
              expression.leftEyebrowOffset + const Offset(-2.0, -3.0),
          rightEyebrowOffset:
              expression.rightEyebrowOffset + const Offset(2.0, -3.0),
          emotionEmojis: [...expression.emotionEmojis, "🐱"],
        );
      case CharacterSkin.dog:
        // Adjust mouth and add doggy elements
        return expression.copyWith(
          mouthCurvature: expression.mouthCurvature + 0.2,
          emotionEmojis: [...expression.emotionEmojis, "🐶"],
        );
      case CharacterSkin.alien:
        // More extreme expressions for alien
        return expression.copyWith(
          leftEyeOpenness: expression.leftEyeOpenness * 1.2,
          rightEyeOpenness: expression.rightEyeOpenness * 1.2,
          emotionEmojis: [...expression.emotionEmojis, "👽"],
          particleEffects: [
            ...expression.particleEffects,
            ParticleEffect(
              type: ParticleType.star,
              color: Colors.greenAccent,
              count: 5,
            ),
          ],
        );
      case CharacterSkin.panda:
        // Soften expressions for panda
        return expression.copyWith(
          leftEyebrowOffset: expression.leftEyebrowOffset * 0.8,
          rightEyebrowOffset: expression.rightEyebrowOffset * 0.8,
          emotionEmojis: [...expression.emotionEmojis, "🐼"],
        );
      case CharacterSkin.underwater:
        // Add bubble effects for underwater
        return expression.copyWith(
          emotionEmojis: [...expression.emotionEmojis, "🐠", "🌊"],
          particleEffects: [
            ...expression.particleEffects,
            ParticleEffect(
              type: ParticleType.bubble,
              color: Colors.lightBlueAccent,
              count: 8,
            ),
          ],
        );
      case CharacterSkin.space:
        // Add space themed effects
        return expression.copyWith(
          emotionEmojis: [...expression.emotionEmojis, "🚀", "🌠"],
          particleEffects: [
            ...expression.particleEffects,
            ParticleEffect(
              type: ParticleType.star,
              color: Colors.white,
              count: 12,
            ),
          ],
        );
      case CharacterSkin.robot:
      default:
        return expression;
    }
  }

  // Get skin color based on character skin
  Color _getSkinColor(CharacterSkin skin, Color defaultColor) {
    switch (skin) {
      case CharacterSkin.cat:
        return const Color(0xFFFEF9E7); // Light cream color
      case CharacterSkin.dog:
        return const Color(0xFFFAE5D3); // Light tan
      case CharacterSkin.alien:
        return const Color(0xFFD5F5E3); // Light green
      case CharacterSkin.panda:
        return Colors.white;
      case CharacterSkin.underwater:
        return const Color(0xFFD4E6F1); // Light blue
      case CharacterSkin.space:
        return const Color(0xFFD2B4DE); // Light purple
      case CharacterSkin.robot:
      default:
        return defaultColor;
    }
  }
}
