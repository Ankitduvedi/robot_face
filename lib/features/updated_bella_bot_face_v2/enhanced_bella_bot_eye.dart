// lib/widgets/enhanced_bella_bot_eye.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart'
    show blinkingProvider, eyePupilPositionProvider;
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_provider.dart';

class EnhancedBellaBotEye extends ConsumerWidget {
  final bool isLeft;
  final double openness;
  final double screenWidth;
  final double screenHeight;
  final CharacterSkin skin;

  const EnhancedBellaBotEye({
    Key? key,
    required this.isLeft,
    required this.openness,
    required this.screenWidth,
    required this.screenHeight,
    required this.skin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pupilOffset = ref.watch(eyePupilPositionProvider);
    final isBlinking = ref.watch(blinkingProvider);
    final expression = ref.watch(bellaBotExpressionProvider);
    final animationState = ref.watch(animationStateProvider);
    final themeData = ref.watch(themeDataProvider);

    // Get expression specific openness for this eye (left or right)
    final effectiveOpenness =
        isBlinking
            ? 0.1
            : (isLeft
                    ? expression.leftEyeOpenness
                    : expression.rightEyeOpenness) *
                openness;

    // Dimensions for the open eye
    final double eyeDiameter = (3 * screenWidth) / 10;
    final double closedHeight = eyeDiameter / 7; // Height when closed

    // Eye height transitions based on openness factor and possible animation
    double currentHeight =
        eyeDiameter * (effectiveOpenness > 0.1 ? effectiveOpenness : 0.1);

    // For very closed eyes, use a rounded rectangle shape
    final useCapsuleShape = effectiveOpenness < 0.3;

    // Apply theme colors for eyes
    final eyeWhiteColor = Colors.white; // Always white for contrast
    final eyePupilColor =
        expression.eyeColors.isNotEmpty
            ? expression.eyeColors.first
            : themeData.eyeColor;

    // Apply special eye styles for character skins
    BoxDecoration eyeDecoration;
    switch (skin) {
      case CharacterSkin.cat:
        eyeDecoration = _getCatEyeDecoration(effectiveOpenness, eyeWhiteColor);
        break;
      case CharacterSkin.alien:
        eyeDecoration = _getAlienEyeDecoration(
          effectiveOpenness,
          eyeWhiteColor,
        );
        break;
      case CharacterSkin.underwater:
        eyeDecoration = _getUnderwaterEyeDecoration(
          effectiveOpenness,
          eyeWhiteColor,
          animationState,
        );
        break;
      case CharacterSkin.space:
        eyeDecoration = _getSpaceEyeDecoration(
          effectiveOpenness,
          eyeWhiteColor,
          themeData,
        );
        break;
      case CharacterSkin.dog:
      case CharacterSkin.panda:
      case CharacterSkin.robot:
      default:
        eyeDecoration = BoxDecoration(
          color: eyeWhiteColor,
          borderRadius: BorderRadius.circular(
            useCapsuleShape ? 15 : eyeDiameter / 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
        break;
    }

    return Container(
      width: eyeDiameter,
      height: currentHeight,
      decoration: eyeDecoration,
      child: _buildPupil(
        pupilOffset,
        effectiveOpenness,
        eyeDiameter,
        eyePupilColor,
        expression,
        animationState,
      ),
    );
  }

  BoxDecoration _getCatEyeDecoration(double openness, Color eyeWhiteColor) {
    // Cat eyes with vertical pupils
    return BoxDecoration(
      color: eyeWhiteColor,
      borderRadius:
          openness < 0.3
              ? BorderRadius.circular(15)
              : BorderRadius.vertical(
                top: Radius.circular(openness * 20),
                bottom: Radius.circular(openness * 20),
              ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxDecoration _getAlienEyeDecoration(double openness, Color eyeWhiteColor) {
    // Alien eyes are larger and more oval
    return BoxDecoration(
      color: eyeWhiteColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(openness * 30),
        bottom: Radius.circular(openness * 30),
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          eyeWhiteColor,
          eyeWhiteColor.withGreen(eyeWhiteColor.green - 20),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxDecoration _getUnderwaterEyeDecoration(
    double openness,
    Color eyeWhiteColor,
    EnhancedAnimationState animationState,
  ) {
    // Underwater eyes have bubble-like appearance
    return BoxDecoration(
      color: eyeWhiteColor,
      borderRadius: BorderRadius.circular(openness < 0.3 ? 15 : 50),
      border: Border.all(color: Colors.lightBlue.withOpacity(0.3), width: 2.0),
      gradient: RadialGradient(
        center: Alignment(
          sin(animationState.floatValue * pi) * 0.2,
          cos(animationState.floatValue * pi) * 0.2,
        ),
        radius: 0.8,
        colors: [Colors.white, eyeWhiteColor.withOpacity(0.9)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    );
  }

  BoxDecoration _getSpaceEyeDecoration(
    double openness,
    Color eyeWhiteColor,
    RobotThemeData themeData,
  ) {
    // Space-themed eyes have tech-like appearance
    return BoxDecoration(
      color: eyeWhiteColor,
      borderRadius: BorderRadius.circular(openness < 0.3 ? 15 : 30),
      border: Border.all(
        color: themeData.accentColor.withOpacity(0.7),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: themeData.accentColor.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }

  Widget _buildPupil(
    Offset pupilOffset,
    double openness,
    double eyeDiameter,
    Color pupilColor,
    BellaBotExpression expression,
    EnhancedAnimationState animationState,
  ) {
    if (openness < 0.2) return Container(); // No pupil for nearly closed eyes

    // For certain expressions, use special pupils
    if (expression.type == ExpressionType.loving) {
      return _buildHeartPupil(eyeDiameter, pupilOffset, animationState);
    } else if (expression.type == ExpressionType.excited ||
        expression.type == ExpressionType.surprised) {
      return _buildStarPupil(
        eyeDiameter,
        pupilOffset,
        pupilColor,
        animationState,
      );
    } else if (expression.type == ExpressionType.processing) {
      return _buildProcessingPupil(
        eyeDiameter,
        pupilOffset,
        pupilColor,
        animationState,
      );
    }

    // Handle different pupils for different character skins
    switch (skin) {
      case CharacterSkin.cat:
        return _buildCatPupil(pupilOffset, openness, eyeDiameter, pupilColor);
      case CharacterSkin.alien:
        return _buildAlienPupil(
          pupilOffset,
          openness,
          eyeDiameter,
          pupilColor,
          animationState,
        );
      case CharacterSkin.underwater:
        return _buildUnderwaterPupil(
          pupilOffset,
          openness,
          eyeDiameter,
          pupilColor,
          animationState,
        );
      case CharacterSkin.space:
        return _buildSpacePupil(
          pupilOffset,
          openness,
          eyeDiameter,
          pupilColor,
          animationState,
        );
      case CharacterSkin.dog:
      case CharacterSkin.panda:
      case CharacterSkin.robot:
      default:
        return Transform.translate(
          offset: pupilOffset,
          child: Center(
            child: ClipOval(
              child: Container(
                width: eyeDiameter / 1.5, // Fixed width for the pupil
                height: eyeDiameter / 1.5 * openness,
                color: pupilColor,
                child:
                    openness > 0.5
                        ? Stack(
                          children: [
                            // Highlight in pupil to make it look more lively
                            Positioned(
                              top: eyeDiameter / 5,
                              left: eyeDiameter / 5,
                              child: Container(
                                width: eyeDiameter / 6,
                                height: eyeDiameter / 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        )
                        : null,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildCatPupil(
    Offset pupilOffset,
    double openness,
    double eyeDiameter,
    Color pupilColor,
  ) {
    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Container(
          width: eyeDiameter / 1.5, // Width of pupil
          height: eyeDiameter / 1.5 * openness, // Height based on openness
          decoration: BoxDecoration(
            color: pupilColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(100),
              bottom: const Radius.circular(100),
            ),
          ),
          child: Center(
            child: Container(
              width: eyeDiameter / 10,
              height: eyeDiameter / 1.8 * openness,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(eyeDiameter / 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlienPupil(
    Offset pupilOffset,
    double openness,
    double eyeDiameter,
    Color pupilColor,
    EnhancedAnimationState animationState,
  ) {
    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Container(
          width: eyeDiameter / 1.3, // Wider alien pupils
          height: eyeDiameter / 1.3 * openness,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                sin(animationState.floatValue * pi) * 0.3,
                cos(animationState.floatValue * pi) * 0.3,
              ),
              radius: 0.7,
              colors: [pupilColor.withOpacity(0.7), pupilColor],
            ),
            borderRadius: BorderRadius.circular(eyeDiameter / 3),
          ),
          child: Stack(
            children: [
              // Inner pupil
              Center(
                child: Container(
                  width: eyeDiameter / 4,
                  height: eyeDiameter / 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: pupilColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Reflection
              Positioned(
                top: eyeDiameter / 6,
                left: eyeDiameter / 5,
                child: Container(
                  width: eyeDiameter / 10,
                  height: eyeDiameter / 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnderwaterPupil(
    Offset pupilOffset,
    double openness,
    double eyeDiameter,
    Color pupilColor,
    EnhancedAnimationState animationState,
  ) {
    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Container(
          width: eyeDiameter / 1.8,
          height: eyeDiameter / 1.8 * openness,
          decoration: BoxDecoration(
            color: pupilColor,
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(0.3, -0.3),
              radius: 0.8,
              colors: [pupilColor.withOpacity(0.6), pupilColor],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main reflection
              Positioned(
                top: eyeDiameter / 7,
                left: eyeDiameter / 6,
                child: Container(
                  width: eyeDiameter / 8,
                  height: eyeDiameter / 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Small bubble reflections
              Positioned(
                top: eyeDiameter / 5,
                right: eyeDiameter / 6,
                child: Container(
                  width: eyeDiameter / 16,
                  height: eyeDiameter / 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpacePupil(
    Offset pupilOffset,
    double openness,
    double eyeDiameter,
    Color pupilColor,
    EnhancedAnimationState animationState,
  ) {
    // Create a tech-looking pupil with scanning effect
    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Container(
          width: eyeDiameter / 1.5,
          height: eyeDiameter / 1.5 * openness,
          decoration: BoxDecoration(
            color: pupilColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(eyeDiameter / 10),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              // Scanning line animation
              Positioned(
                left: (eyeDiameter / 1.5) * animationState.floatValue,
                top: 0,
                bottom: 0,
                width: 2,
                child: Container(color: Colors.white.withOpacity(0.7)),
              ),

              // Digital-looking pattern
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 9,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeartPupil(
    double eyeDiameter,
    Offset pupilOffset,
    EnhancedAnimationState animationState,
  ) {
    // Heart-shaped pupils for love expression
    final heartSize = eyeDiameter / 2.5;
    final pulseFactor = 1.0 + sin(animationState.glowValue * pi * 2) * 0.1;

    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Transform.scale(
          scale: pulseFactor,
          child: CustomPaint(
            size: Size(heartSize, heartSize),
            painter: HeartPainter(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildStarPupil(
    double eyeDiameter,
    Offset pupilOffset,
    Color pupilColor,
    EnhancedAnimationState animationState,
  ) {
    // Star-shaped pupils for excited/surprised expressions
    final starSize = eyeDiameter / 2.5;
    final pulseFactor = 1.0 + sin(animationState.glowValue * pi * 2) * 0.1;

    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: Transform.scale(
          scale: pulseFactor,
          child: Transform.rotate(
            angle: animationState.floatValue * 0.2,
            child: CustomPaint(
              size: Size(starSize, starSize),
              painter: StarPainter(color: pupilColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingPupil(
    double eyeDiameter,
    Offset pupilOffset,
    Color pupilColor,
    EnhancedAnimationState animationState,
  ) {
    // Loading/processing animation in pupils
    return Transform.translate(
      offset: pupilOffset,
      child: Center(
        child: SizedBox(
          width: eyeDiameter / 1.8,
          height: eyeDiameter / 1.8,
          child: CircularProgressIndicator(
            color: pupilColor,
            strokeWidth: 4,
            value: animationState.isGlowing ? null : animationState.glowValue,
          ),
        ),
      ),
    );
  }
}

// Custom painters for special pupil shapes

class HeartPainter extends CustomPainter {
  final Color color;

  HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    // Draw a heart shape
    path.moveTo(size.width / 2, size.height * 0.75);

    // Left curve
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.05,
      size.height * 0.35,
      size.width / 2,
      size.height * 0.05,
    );

    // Right curve
    path.cubicTo(
      size.width * 0.95,
      size.height * 0.35,
      size.width * 0.75,
      size.height * 0.5,
      size.width / 2,
      size.height * 0.75,
    );

    canvas.drawPath(path, paint);

    // Add a highlight
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.1,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = size.width / 4;

    for (int i = 0; i < 5; i++) {
      final outerAngle = i * 2 * pi / 5 - pi / 2;
      final innerAngle = outerAngle + pi / 5;

      final outerX = centerX + cos(outerAngle) * outerRadius;
      final outerY = centerY + sin(outerAngle) * outerRadius;
      final innerX = centerX + cos(innerAngle) * innerRadius;
      final innerY = centerY + sin(innerAngle) * innerRadius;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }

      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);

    // Add a highlight
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX * 0.8, centerY * 0.8),
      size.width * 0.1,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
