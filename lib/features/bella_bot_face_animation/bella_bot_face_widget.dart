// lib/widgets/bella_bot_face.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_eye_widget.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_painters.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';

class BellaBotFace extends ConsumerStatefulWidget {
  const BellaBotFace({Key? key}) : super(key: key);

  @override
  _BellaBotFaceState createState() => _BellaBotFaceState();
}

class _BellaBotFaceState extends ConsumerState<BellaBotFace>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _bounceController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  Timer? _blinkTimer;
  final Random _random = Random();

  // Constants for screen dimensions
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();

    // Blink animation controller
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Add listener to update the blinking state
    _blinkController.addListener(() {
      if (_blinkController.value > 0.5) {
        ref.read(blinkingProvider.notifier).state = true;
      } else {
        ref.read(blinkingProvider.notifier).state = false;
      }
    });

    // Subtle bounce animation for the whole face
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Listener for bounce animation
    _bounceController.addListener(() {
      ref.read(animationStateProvider.notifier).state = ref
          .read(animationStateProvider)
          .copyWith(bounceValue: _bounceController.value);
    });

    // Floating animation for a gentle hovering effect
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Listener for float animation
    _floatAnimation.addListener(() {
      ref.read(animationStateProvider.notifier).state = ref
          .read(animationStateProvider)
          .copyWith(floatValue: _floatAnimation.value);
    });

    // Start random blinking
    _scheduleBlink();
  }

  void _scheduleBlink() {
    // Random timing for natural blink effect
    final nextBlinkDelay = Duration(milliseconds: 2000 + _random.nextInt(4000));
    _blinkTimer = Timer(nextBlinkDelay, () {
      _blink();
      _scheduleBlink();
    });
  }

  void _blink() {
    _blinkController.forward().then((_) {
      _blinkController.reverse();
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
    // Get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    final expression = ref.watch(bellaBotExpressionProvider);
    final animationState = ref.watch(animationStateProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Apply floating animation
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, animationState.floatValue),
              child: child,
            );
          },
          child: AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              // Apply bounce animation
              return Transform.scale(
                scale: 1.0 + animationState.bounceValue * 0.02,
                child: child,
              );
            },
            child: _buildFace(expression),
          ),
        ),
      ],
    );
  }

  Widget _buildFace(BellaBotExpression expression) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Left Eyebrow
        SizedBox(
          height: screenWidth / 30,
          width: screenWidth / 2,
          child: CustomPaint(
            painter: EyebrowPainter(
              isLeft: true,
              offset: expression.leftEyebrowOffset,
              color: Colors.white,
              thickness: 30.0,
            ),
          ),
        ),

        // Right Eyebrow
        SizedBox(
          height: screenWidth / 30,
          width: screenWidth / 2,
          child: CustomPaint(
            painter: EyebrowPainter(
              isLeft: false,
              offset: expression.rightEyebrowOffset,
              color: Colors.white,
              thickness: 30.0,
            ),
          ),
        ),

        // Eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Eye
            BellaBotEye(
              isLeft: true,
              openness: 1.0,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            SizedBox(width: 120),
            // Right Eye
            BellaBotEye(
              isLeft: false,
              openness: 1.0,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ],
        ),

        // Mouth and other facial elements
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Nose
            Container(
              width: screenWidth / 35,
              height: screenWidth / 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            SizedBox(height: screenHeight / 50),

            // Mouth
            SizedBox(
              height: screenWidth / 30,
              width: screenWidth / 2,
              child: CustomPaint(
                painter: MouthPainter(
                  curvature: expression.mouthCurvature,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight / 5.2),
          ],
        ),

        // Blush (conditionally shown)
        if (expression.hasBlush)
          SizedBox(
            width: screenWidth,
            height: screenHeight / 2,
            child: CustomPaint(
              painter: BlushPainter(color: Colors.pink, size: 1.0),
            ),
          ),
      ],
    );
  }
}
