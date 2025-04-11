// screens/robot_face_page.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/face_animation/face_modal.dart';
import 'package:robot_display_v2/features/face_animation/provider.dart';
import 'package:robot_display_v2/features/face_animation/widget_robot_face.dart';

class RobotFacePage extends ConsumerStatefulWidget {
  const RobotFacePage({Key? key}) : super(key: key);

  @override
  ConsumerState<RobotFacePage> createState() => _RobotFacePageState();
}

class _RobotFacePageState extends ConsumerState<RobotFacePage>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _bounceController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  Timer? _blinkTimer;
  Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Blink animation controller
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Subtle bounce animation for the whole face
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start random blinking
    _scheduleBlink();
  }

  void _scheduleBlink() {
    final nextBlinkDelay = Duration(milliseconds: 1000 + _random.nextInt(4000));
    _blinkTimer = Timer(nextBlinkDelay, () {
      _blink();
      _scheduleBlink();
    });
  }

  void _blink() {
    ref.read(blinkingProvider.notifier).state = true;
    _blinkController.forward().then((_) {
      _blinkController.reverse().then((_) {
        ref.read(blinkingProvider.notifier).state = false;
      });
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _bounceController.dispose();
    _floatController.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Robot Face Animation'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + _bounceController.value * 0.01,
                        child: RobotFace(blinkController: _blinkController),
                      );
                    },
                  ),
                ),
              ),
            ),
            _buildExpressionControls(),
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
          const Text(
            'Facial Expressions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              for (final expression in [
                ExpressionType.happy,
                ExpressionType.sad,
                ExpressionType.surprised,
                ExpressionType.angry,
                ExpressionType.wink,
                ExpressionType.love,
                ExpressionType.thinking,
                ExpressionType.confused,
              ])
                _buildExpressionButton(expression),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              for (final expression in [
                ExpressionType.cute,
                ExpressionType.sleepy,
                ExpressionType.dead,
                ExpressionType.blushing,
                ExpressionType.crying,
                ExpressionType.catty,
                ExpressionType.vampire,
                ExpressionType.glasses,
              ])
                _buildExpressionButton(expression),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              for (final expression in [
                ExpressionType.eyeRoll,
                ExpressionType.laughing,
                ExpressionType.smirk,
                ExpressionType.closed,
                ExpressionType.worried,
                ExpressionType.music,
                ExpressionType.neutral,
              ])
                _buildExpressionButton(expression),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionButton(ExpressionType expression) {
    return ElevatedButton(
      onPressed: () {
        ref.read(faceExpressionProvider.notifier).setExpression(expression);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      child: Text(
        _expressionToDisplayName(expression),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _expressionToDisplayName(ExpressionType expression) {
    switch (expression) {
      case ExpressionType.eyeRoll:
        return 'Eye Roll';
      default:
        return expression.name[0].toUpperCase() + expression.name.substring(1);
    }
  }
}
