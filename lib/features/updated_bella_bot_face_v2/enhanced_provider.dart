// lib/providers/enhanced_providers.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_expression_factory.dart';

// Environment & Theme providers
final robotThemeProvider = StateProvider<RobotTheme>(
  (ref) => RobotTheme.default_theme,
);
final characterSkinProvider = StateProvider<CharacterSkin>(
  (ref) => CharacterSkin.robot,
);
final accessoryProvider = StateProvider<AccessoryType>(
  (ref) => AccessoryType.none,
);
final backgroundProvider = StateProvider<List<Color>>((ref) {
  // Initial background is based on default theme
  return const [Color(0xFF303030), Color(0xFF424242)];
});

// Enhanced theme data provider
final themeDataProvider = Provider<RobotThemeData>((ref) {
  final theme = ref.watch(robotThemeProvider);
  final factory = ExpressionFactory();
  return factory.getThemeData(theme);
});

// Audio visualization provider
final audioVisualizerProvider = StateProvider<AudioVisualData>((ref) {
  final expression = ref.watch(bellaBotExpressionProvider);

  // Automatically set visualization active based on expression
  final isActive =
      expression.type == ExpressionType.listening ||
      expression.type == ExpressionType.processing;

  // Generate random amplitudes for simulation
  final random = Random();
  List<double> amplitudes = [];

  if (isActive) {
    amplitudes = List.generate(15, (i) {
      if (expression.type == ExpressionType.listening) {
        // More random for listening
        return 0.2 + random.nextDouble() * 0.8;
      } else {
        // More structured for processing
        final position = i / 15;
        if (position < 0.4 || position > 0.6) {
          return 0.2 + random.nextDouble() * 0.3;
        } else {
          return 0.6 + random.nextDouble() * 0.4;
        }
      }
    });
  }

  return AudioVisualData(
    amplitudes: amplitudes,
    isActive: isActive,
    mainFrequency: isActive ? (40 + random.nextDouble() * 200) : 0,
  );
});

// Particle effects provider
final particleEffectsProvider = StateProvider<List<ParticleEffect>>((ref) {
  final expression = ref.watch(bellaBotExpressionProvider);
  return expression.particleEffects;
});

// Animation values provider
final animationStateProvider =
    StateNotifierProvider<AnimationStateNotifier, EnhancedAnimationState>((
      ref,
    ) {
      return AnimationStateNotifier();
    });

// Speech/thought bubble provider
final bubbleProvider = StateProvider<BubbleState>((ref) {
  final expression = ref.watch(bellaBotExpressionProvider);

  // Default positions adjusted by screen dimensions
  const double speechX = 160;
  const double speechY = 50;
  const double thoughtX = 160;
  const double thoughtY = 80;

  return BubbleState(
    showSpeechBubble: expression.speechBubbleText != null,
    showThoughtBubble: expression.thoughtBubbleText != null,
    speechBubbleText: expression.speechBubbleText ?? "",
    thoughtBubbleText: expression.thoughtBubbleText ?? "",
    speechBubblePosition: const Offset(speechX, speechY),
    thoughtBubblePosition: const Offset(thoughtX, thoughtY),
    emojis: expression.emotionEmojis,
  );
});

// Device motion provider - for environment reactions
final deviceMotionProvider = StateProvider<DeviceMotionData>((ref) {
  return const DeviceMotionData();
});

// Season theme provider - for seasonal elements
final seasonalThemeProvider = StateProvider<SeasonalTheme>((ref) {
  // Determine current season
  final now = DateTime.now();
  final month = now.month;

  if (month == 12 || month == 1 || month == 2) {
    return SeasonalTheme.winter;
  } else if (month >= 3 && month <= 5) {
    return SeasonalTheme.spring;
  } else if (month >= 6 && month <= 8) {
    return SeasonalTheme.summer;
  } else {
    return SeasonalTheme.autumn;
  }
});

// Expression provider (enhanced version)
final bellaBotExpressionProvider =
    StateNotifierProvider<EnhancedExpressionNotifier, BellaBotExpression>((
      ref,
    ) {
      final themeData = ref.watch(themeDataProvider);
      final skin = ref.watch(characterSkinProvider);
      final accessory = ref.watch(accessoryProvider);

      return EnhancedExpressionNotifier(
        themeData: themeData,
        skin: skin,
        accessory: accessory,
      );
    });

// Enhanced animation state
class EnhancedAnimationState {
  final double floatValue;
  final double bounceValue;
  final double glowValue;
  final double particleValue;
  final double backgroundValue;
  final double accessoryValue;
  final bool isFloating;
  final bool isBouncing;
  final bool isGlowing;

  EnhancedAnimationState({
    this.floatValue = 0.0,
    this.bounceValue = 0.0,
    this.glowValue = 0.0,
    this.particleValue = 0.0,
    this.backgroundValue = 0.0,
    this.accessoryValue = 0.0,
    this.isFloating = true,
    this.isBouncing = true,
    this.isGlowing = true,
  });

  EnhancedAnimationState copyWith({
    double? floatValue,
    double? bounceValue,
    double? glowValue,
    double? particleValue,
    double? backgroundValue,
    double? accessoryValue,
    bool? isFloating,
    bool? isBouncing,
    bool? isGlowing,
  }) {
    return EnhancedAnimationState(
      floatValue: floatValue ?? this.floatValue,
      bounceValue: bounceValue ?? this.bounceValue,
      glowValue: glowValue ?? this.glowValue,
      particleValue: particleValue ?? this.particleValue,
      backgroundValue: backgroundValue ?? this.backgroundValue,
      accessoryValue: accessoryValue ?? this.accessoryValue,
      isFloating: isFloating ?? this.isFloating,
      isBouncing: isBouncing ?? this.isBouncing,
      isGlowing: isGlowing ?? this.isGlowing,
    );
  }
}

// Animation state notifier
class AnimationStateNotifier extends StateNotifier<EnhancedAnimationState> {
  AnimationStateNotifier() : super(EnhancedAnimationState()) {
    _startAnimations();
  }

  Timer? _floatTimer;
  Timer? _bounceTimer;
  Timer? _glowTimer;
  Timer? _particleTimer;
  Timer? _backgroundTimer;
  Timer? _accessoryTimer;

  void _startAnimations() {
    // Each animation runs at different speeds for natural variance
    _floatTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 3000;
      state = state.copyWith(floatValue: sin(t));
    });

    _bounceTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 2000;
      state = state.copyWith(bounceValue: (sin(t) + 1) / 2);
    });

    _glowTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 4000;
      state = state.copyWith(glowValue: (sin(t) + 1) / 2);
    });

    _particleTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 5000;
      state = state.copyWith(particleValue: t % 1);
    });

    _backgroundTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 10000;
      state = state.copyWith(backgroundValue: (sin(t) + 1) / 2);
    });

    _accessoryTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      final t = DateTime.now().millisecondsSinceEpoch / 6000;
      state = state.copyWith(accessoryValue: (sin(t) + 1) / 2);
    });
  }

  void toggleFloating(bool value) {
    state = state.copyWith(isFloating: value);
  }

  void toggleBouncing(bool value) {
    state = state.copyWith(isBouncing: value);
  }

  void toggleGlowing(bool value) {
    state = state.copyWith(isGlowing: value);
  }

  @override
  void dispose() {
    _floatTimer?.cancel();
    _bounceTimer?.cancel();
    _glowTimer?.cancel();
    _particleTimer?.cancel();
    _backgroundTimer?.cancel();
    _accessoryTimer?.cancel();
    super.dispose();
  }
}

// Speech bubble state
class BubbleState {
  final bool showSpeechBubble;
  final bool showThoughtBubble;
  final String speechBubbleText;
  final String thoughtBubbleText;
  final Offset speechBubblePosition;
  final Offset thoughtBubblePosition;
  final List<String> emojis;

  const BubbleState({
    this.showSpeechBubble = false,
    this.showThoughtBubble = false,
    this.speechBubbleText = "",
    this.thoughtBubbleText = "",
    this.speechBubblePosition = Offset.zero,
    this.thoughtBubblePosition = Offset.zero,
    this.emojis = const [],
  });
}

// Device motion data for reactive movements
class DeviceMotionData {
  final double tiltX;
  final double tiltY;
  final double tiltZ;
  final bool isShaking;
  final double lightIntensity;

  const DeviceMotionData({
    this.tiltX = 0.0,
    this.tiltY = 0.0,
    this.tiltZ = 0.0,
    this.isShaking = false,
    this.lightIntensity = 0.5,
  });
}

// Seasonal themes
enum SeasonalTheme { winter, spring, summer, autumn }

// Enhanced expression notifier
class EnhancedExpressionNotifier extends StateNotifier<BellaBotExpression> {
  Timer? _expressionTimer;
  Timer? _randomExpressionTimer;
  Timer? _bubbleTimer;
  final Random _random = Random();
  final ExpressionFactory _factory = ExpressionFactory();
  final RobotThemeData themeData;
  CharacterSkin skin;
  AccessoryType accessory;

  EnhancedExpressionNotifier({
    required this.themeData,
    required this.skin,
    required this.accessory,
  }) : super(ExpressionFactory().getNeutralExpression()) {
    _factory.currentTheme = RobotTheme.default_theme;
    _factory.currentSkin = skin;
    _factory.currentAccessory = accessory;
    state = _factory.getExpression(ExpressionType.neutral);
    _startRandomExpressions();
  }

  void updateTheme(RobotTheme theme) {
    _factory.currentTheme = theme;
    // Update current expression with new theme
    setExpression(state.type);
  }

  void updateSkin(CharacterSkin newSkin) {
    skin = newSkin;
    _factory.currentSkin = newSkin;
    // Update current expression with new skin
    setExpression(state.type);
  }

  void updateAccessory(AccessoryType newAccessory) {
    accessory = newAccessory;
    _factory.currentAccessory = newAccessory;
    // Update current expression with new accessory
    setExpression(state.type);
  }

  void _startRandomExpressions() {
    _randomExpressionTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      if (_random.nextDouble() > 0.6) {
        // Reduce randomness a bit (40% chance)
        _showRandomExpression();
      }
    });

    // Also randomly show speech/thought bubbles occasionally
    _bubbleTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_random.nextDouble() > 0.7 &&
          state.speechBubbleText == null &&
          state.thoughtBubbleText == null) {
        // Show a random message
        _showRandomBubble();
      }
    });
  }

  void _showRandomExpression() {
    final expressions = [
      ExpressionType.happy,
      ExpressionType.sad,
      ExpressionType.surprised,
      ExpressionType.wink,
      ExpressionType.blushing,
      ExpressionType.thinking,
      ExpressionType.excited,
      ExpressionType.confused,
    ];
    final randomExpression = expressions[_random.nextInt(expressions.length)];
    setExpression(randomExpression);
  }

  void _showRandomBubble() {
    const List<String> randomMessages = [
      "Hello there!",
      "How are you today?",
      "What a lovely day!",
      "I'm feeling great!",
      "I wonder what time it is...",
      "Is it going to rain today?",
      "I'm a friendly robot!",
      "Do you like my new look?",
      "Beep boop!",
      "I'm thinking...",
      "What should I do next?",
      "I'm learning new things!",
    ];

    final message = randomMessages[_random.nextInt(randomMessages.length)];

    // 50% chance for speech vs thought bubble
    if (_random.nextBool()) {
      setExpression(state.type, speechBubbleText: message);
    } else {
      setExpression(state.type, thoughtBubbleText: message);
    }

    // Clear the bubble after a few seconds
    Timer(Duration(milliseconds: 3000 + _random.nextInt(2000)), () {
      setExpression(
        state.type,
        speechBubbleText: null,
        thoughtBubbleText: null,
      );
    });
  }

  void setExpression(
    ExpressionType expression, {
    String? speechBubbleText,
    String? thoughtBubbleText,
  }) {
    // Cancel any ongoing expression timer
    _expressionTimer?.cancel();

    // Get new expression from factory
    BellaBotExpression newExpression = _factory.getExpression(expression);

    // Override bubble text if provided
    if (speechBubbleText != null || thoughtBubbleText != null) {
      newExpression = newExpression.copyWith(
        speechBubbleText: speechBubbleText,
        thoughtBubbleText: thoughtBubbleText,
      );
    }

    state = newExpression;

    // For expressions that should be temporary, set a timer to return to neutral
    if (expression != ExpressionType.neutral &&
        expression != ExpressionType.happy &&
        expression != ExpressionType.sleepy) {
      _expressionTimer = Timer(
        Duration(milliseconds: 2500 + _random.nextInt(1500)),
        () {
          // Only change back if we're still showing the same expression
          if (state.type == expression) {
            state = _factory.getExpression(ExpressionType.neutral);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _expressionTimer?.cancel();
    _randomExpressionTimer?.cancel();
    _bubbleTimer?.cancel();
    super.dispose();
  }
}
