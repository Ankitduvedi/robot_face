// providers/face_providers.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/face_animation/expression.dart';
import 'package:robot_display_v2/features/face_animation/face_modal.dart';

// Providers
final faceExpressionProvider =
    StateNotifierProvider<FaceExpressionNotifier, FaceExpression>((ref) {
      return FaceExpressionNotifier();
    });

final blinkingProvider = StateProvider<bool>((ref) => false);

class FaceExpressionNotifier extends StateNotifier<FaceExpression> {
  Timer? _expressionTimer;
  Timer? _randomExpressionTimer;
  Random _random = Random();
  final ExpressionFactory _factory = ExpressionFactory();

  FaceExpressionNotifier() : super(ExpressionFactory().getNeutralExpression()) {
    _startRandomExpressions();
  }

  void _startRandomExpressions() {
    _randomExpressionTimer = Timer.periodic(const Duration(seconds: 8), (_) {
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
        Duration(milliseconds: 1500 + _random.nextInt(1500)),
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
