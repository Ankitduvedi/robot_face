// lib/screens/bella_bot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_animation_manager.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_widget.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';

class BellaBotScreen extends ConsumerStatefulWidget {
  const BellaBotScreen({super.key});

  @override
  BellaBotScreenState createState() => BellaBotScreenState();
}

class BellaBotScreenState extends ConsumerState<BellaBotScreen>
    with TickerProviderStateMixin {
  late BellaBotAnimationManager animationManager;

  @override
  void initState() {
    super.initState();
    // Initialize animation manager after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationManager = BellaBotAnimationManager(vsync: this, ref: ref);
    });
  }

  @override
  void dispose() {
    animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for robot

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                // Face follows touch position
                onPanUpdate: (details) {
                  animationManager.lookAt(details.localPosition);
                },
                child: const Center(child: BellaBotFace()),
              ),
            ),
            // Expanded(flex: 1, child: _buildExpressionControls()),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressionControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 2.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                for (final expression in ExpressionType.values)
                  _buildExpressionButton(expression),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionButton(ExpressionType expression) {
    // Current expression
    final currentExpression = ref.watch(bellaBotExpressionProvider).type;
    final isSelected = currentExpression == expression;

    return ElevatedButton(
      onPressed: () {
        ref.read(bellaBotExpressionProvider.notifier).setExpression(expression);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.blue.shade700 : Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
      child: Text(
        _expressionToDisplayName(expression),
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _expressionToDisplayName(ExpressionType expression) {
    switch (expression) {
      case ExpressionType.happy:
        return 'Happy';
      case ExpressionType.sad:
        return 'Sad';
      case ExpressionType.angry:
        return 'Angry';
      case ExpressionType.surprised:
        return 'Surprised';
      case ExpressionType.wink:
        return 'Wink';
      case ExpressionType.neutral:
        return 'Neutral';
      case ExpressionType.blushing:
        return 'Blushing';
      case ExpressionType.sleepy:
        return 'Sleepy';
      case ExpressionType.thinking:
        return 'Thinking';
      case ExpressionType.loving:
        return 'Loving';
      case ExpressionType.confused:
        return 'Confused';
      default:
        return expression.toString().split('.').last;
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    throw UnimplementedError();
  }
}
