// lib/providers/face_providers.dart
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_expression_factory.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';

// Face coordinates provider for face tracking
final faceCoordinatesProvider = StateProvider<List<FaceCoordinate>>(
  (ref) => [],
);

// Expression provider
final bellaBotExpressionProvider =
    StateNotifierProvider<BellaBotExpressionNotifier, BellaBotExpression>((
      ref,
    ) {
      return BellaBotExpressionNotifier();
    });

// Blinking provider
final blinkingProvider = StateProvider<bool>((ref) => false);

// Eye pupil position provider
final eyePupilPositionProvider = StateProvider<Offset>((ref) {
  // Get face coordinates to calculate pupil position
  final faceCoordinates = ref.watch(faceCoordinatesProvider);

  if (faceCoordinates.isEmpty) {
    return Offset.zero;
  }

  // Calculate pupil position based on face position
  final face = faceCoordinates.first;
  const maxEyeBallDistance = 8.0; // Max pupil movement

  // Screen dimensions would come from a constant or provider in a real app
  const screenWidth = 400.0;
  const screenHeight = 800.0;

  // Normalize coordinates for eye movement
  final normalizedX = (face.x / screenWidth) * maxEyeBallDistance;
  final normalizedY = (face.y / screenHeight) * maxEyeBallDistance;

  final offset = Offset(
    normalizedX - maxEyeBallDistance / 2,
    normalizedY - maxEyeBallDistance / 2,
  );

  // Cap offset to keep the eyeball within range
  final maxPointerDistance = maxEyeBallDistance / 2;
  final pointerDistance = sqrt(offset.dx * offset.dx + offset.dy * offset.dy);

  if (pointerDistance > maxPointerDistance) {
    final angle = atan2(offset.dy, offset.dx);
    return Offset(
      cos(angle) * maxPointerDistance,
      sin(angle) * maxPointerDistance,
    );
  }

  return offset;
});

// Animation controller state provider for animations
final animationStateProvider = StateProvider<AnimationState>(
  (ref) => AnimationState(),
);

class AnimationState {
  final bool isFloating;
  final bool isBouncing;
  final double floatValue;
  final double bounceValue;

  AnimationState({
    this.isFloating = true,
    this.isBouncing = true,
    this.floatValue = 0.0,
    this.bounceValue = 0.0,
  });

  AnimationState copyWith({
    bool? isFloating,
    bool? isBouncing,
    double? floatValue,
    double? bounceValue,
  }) {
    return AnimationState(
      isFloating: isFloating ?? this.isFloating,
      isBouncing: isBouncing ?? this.isBouncing,
      floatValue: floatValue ?? this.floatValue,
      bounceValue: bounceValue ?? this.bounceValue,
    );
  }
}

class BellaBotExpressionNotifier extends StateNotifier<BellaBotExpression> {
  Timer? _expressionTimer;
  Timer? _randomExpressionTimer;
  final Random _random = Random();
  final ExpressionFactory _factory = ExpressionFactory();

  BellaBotExpressionNotifier()
    : super(ExpressionFactory().getNeutralExpression()) {
    _startRandomExpressions();
  }

  void _startRandomExpressions() {
    _randomExpressionTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_random.nextBool()) {
        _showRandomExpression();
      }
    });
  }

  void _showRandomExpression() {
    final expressions = ExpressionType.values;
    final randomExpression = expressions[_random.nextInt(expressions.length)];
    setExpression(randomExpression);
  }

  void setExpression(ExpressionType expression) {
    // Cancel any ongoing expression timer
    _expressionTimer?.cancel();

    state = _factory.getExpression(expression);

    // For expressions that should be temporary, set a timer to return to neutral
    if (expression != ExpressionType.neutral &&
        expression != ExpressionType.happy &&
        expression != ExpressionType.sleepy) {
      _expressionTimer = Timer(
        Duration(milliseconds: 2000 + _random.nextInt(2000)),
        () {
          state = _factory.getNeutralExpression();
        },
      );
    }
  }

  @override
  void dispose() {
    _expressionTimer?.cancel();
    _randomExpressionTimer?.cancel();
    super.dispose();
  }
}
