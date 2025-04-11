// lib/widgets/effects/enhanced_background.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_provider.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnhancedBackground extends ConsumerWidget {
  final Widget child;

  const EnhancedBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);
    final expression = ref.watch(bellaBotExpressionProvider);
    final animationState = ref.watch(animationStateProvider);
    final seasonalTheme = ref.watch(seasonalThemeProvider);
    final deviceMotion = ref.watch(deviceMotionProvider);

    // Background colors based on theme and expression
    List<Color> backgroundColors = themeData.backgroundGradient;

    // Adjust background based on expression intensity
    if (expression.type == ExpressionType.happy ||
        expression.type == ExpressionType.excited ||
        expression.type == ExpressionType.loving) {
      // Brighten colors for positive emotions
      backgroundColors =
          backgroundColors
              .map(
                (color) => color
                    .withRed((color.red + 20).clamp(0, 255))
                    .withGreen((color.green + 20).clamp(0, 255)),
              )
              .toList();
    } else if (expression.type == ExpressionType.sad ||
        expression.type == ExpressionType.angry) {
      // Darken colors for negative emotions
      backgroundColors =
          backgroundColors
              .map(
                (color) => color
                    .withRed((color.red - 20).clamp(0, 255))
                    .withGreen((color.green - 20).clamp(0, 255)),
              )
              .toList();
    }

    // Make sure we have enough colors for our stops
    // If we only have 2 colors but need 3 stops, add a middle color
    if (backgroundColors.length == 2 && 3 > backgroundColors.length) {
      // Insert a middle color (blend of the two)
      final middleColor =
          Color.lerp(backgroundColors[0], backgroundColors[1], 0.5)!;
      backgroundColors = [
        backgroundColors[0],
        middleColor,
        backgroundColors[1],
      ];
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundColors,
          // Animate gradient subtly - make sure stops match the number of colors
          stops:
              backgroundColors.length == 3
                  ? [0.0, 0.3 + animationState.backgroundValue * 0.05, 1.0]
                  :
                  // Default stops for 2 colors
                  [0.0, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Add seasonal background elements
          _buildSeasonalElements(seasonalTheme, animationState, deviceMotion),

          // Reactive background effects based on expression
          if (expression.isAnimatedEffect)
            _buildExpressionBackgroundEffects(
              expression,
              themeData,
              animationState,
            ),

          // Character and UI elements
          child,
        ],
      ),
    );
  }

  Widget _buildSeasonalElements(
    SeasonalTheme season,
    EnhancedAnimationState animationState,
    DeviceMotionData deviceMotion,
  ) {
    switch (season) {
      case SeasonalTheme.winter:
        return _buildWinterElements(animationState, deviceMotion);
      case SeasonalTheme.spring:
        return _buildSpringElements(animationState, deviceMotion);
      case SeasonalTheme.summer:
        return _buildSummerElements(animationState, deviceMotion);
      case SeasonalTheme.autumn:
        return _buildAutumnElements(animationState, deviceMotion);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWinterElements(
    EnhancedAnimationState animationState,
    DeviceMotionData deviceMotion,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        children: [
          // Falling snowflakes
          ...List.generate(15, (index) {
            final random = Random(index);
            final size = 8.0 + random.nextDouble() * 10;
            final speedFactor = 0.3 + random.nextDouble() * 0.7;

            // Apply device tilt offset
            final tiltOffsetX = deviceMotion.tiltX * 10;

            return Positioned(
              left: (random.nextDouble() * 400 + tiltOffsetX) % 400,
              top:
                  ((animationState.backgroundValue * 1000 * speedFactor) +
                      (random.nextDouble() * 600)) %
                  600,
              child: Transform.rotate(
                angle: random.nextDouble() * pi * 2,
                child: Icon(
                  Icons.ac_unit,
                  color: Colors.white.withOpacity(0.7),
                  size: size,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSpringElements(
    EnhancedAnimationState animationState,
    DeviceMotionData deviceMotion,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        children: [
          // Floating flower petals
          ...List.generate(10, (index) {
            final random = Random(index);
            final size = 10.0 + random.nextDouble() * 15;
            final speedFactor = 0.2 + random.nextDouble() * 0.4;

            // Apply device tilt offset
            final tiltOffsetX = deviceMotion.tiltX * 15;
            final tiltOffsetY = deviceMotion.tiltY * 15;

            return Positioned(
              left:
                  (random.nextDouble() * 400 +
                      sin(animationState.backgroundValue * pi * 2) * 30 +
                      tiltOffsetX) %
                  400,
              top:
                  ((animationState.backgroundValue * 500 * speedFactor) +
                      (random.nextDouble() * 600) +
                      tiltOffsetY) %
                  600,
              child: Transform.rotate(
                angle:
                    random.nextDouble() * pi * 2 +
                    animationState.backgroundValue * pi,
                child: Icon(
                  Icons.local_florist,
                  color: Colors.pinkAccent.withOpacity(0.7),
                  size: size,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummerElements(
    EnhancedAnimationState animationState,
    DeviceMotionData deviceMotion,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        children: [
          // Sun rays from corner
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.yellow.withOpacity(0.7),
                    Colors.yellow.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Floating bubbles
          ...List.generate(8, (index) {
            final random = Random(index);
            final size = 20.0 + random.nextDouble() * 30;
            final speedFactor = 0.1 + random.nextDouble() * 0.3;

            // Apply device tilt offset
            final tiltOffsetX = deviceMotion.tiltX * 20;
            final tiltOffsetY = deviceMotion.tiltY * 10;

            return Positioned(
              left:
                  (random.nextDouble() * 400 +
                      sin(animationState.backgroundValue * pi * 2) * 20 +
                      tiltOffsetX) %
                  400,
              top:
                  ((animationState.backgroundValue * -300 * speedFactor) +
                      (random.nextDouble() * 600) +
                      tiltOffsetY) %
                  600,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAutumnElements(
    EnhancedAnimationState animationState,
    DeviceMotionData deviceMotion,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        children: [
          // Falling leaves
          ...List.generate(12, (index) {
            final random = Random(index);
            final size = 15.0 + random.nextDouble() * 15;
            final speedFactor = 0.2 + random.nextDouble() * 0.6;
            final isMaple = random.nextBool();

            // Apply device tilt offset
            final tiltOffsetX = deviceMotion.tiltX * 15;

            return Positioned(
              left:
                  (random.nextDouble() * 400 +
                      sin(animationState.backgroundValue * pi * 2 + index) *
                          30 +
                      tiltOffsetX) %
                  400,
              top:
                  ((animationState.backgroundValue * 800 * speedFactor) +
                      (random.nextDouble() * 600)) %
                  600,
              child: Transform.rotate(
                angle:
                    random.nextDouble() * pi * 2 +
                    animationState.backgroundValue * pi,
                child: Icon(
                  isMaple ? Icons.eco : Icons.spa,
                  color:
                      isMaple
                          ? Colors.orange.withOpacity(0.7)
                          : Colors.amber.withOpacity(0.7),
                  size: size,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExpressionBackgroundEffects(
    BellaBotExpression expression,
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    switch (expression.type) {
      case ExpressionType.happy:
      case ExpressionType.excited:
        return _buildHappyBackgroundEffects(themeData, animationState);
      case ExpressionType.sad:
      case ExpressionType.crying:
        return _buildSadBackgroundEffects(themeData, animationState);
      case ExpressionType.angry:
        return _buildAngryBackgroundEffects(themeData, animationState);
      case ExpressionType.loving:
        return _buildLovingBackgroundEffects(themeData, animationState);
      case ExpressionType.surprised:
        return _buildSurprisedBackgroundEffects(themeData, animationState);
      case ExpressionType.processing:
        return _buildProcessingBackgroundEffects(themeData, animationState);
      case ExpressionType.listening:
        return _buildListeningBackgroundEffects(themeData, animationState);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHappyBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Subtle sparkles
        ...List.generate(10, (index) {
          final random = Random(index);
          final size = 10.0 + random.nextDouble() * 10;

          return Positioned(
            left: random.nextDouble() * 400,
            top: random.nextDouble() * 600,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity:
                  random.nextDouble() > animationState.particleValue
                      ? 0.7
                      : 0.0,
              child: Icon(Icons.star, color: Colors.yellow, size: size),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSadBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Rain effect
        ...List.generate(20, (index) {
          final random = Random(index);
          final width = 2.0 + random.nextDouble() * 1.0;
          final height = 10.0 + random.nextDouble() * 15.0;
          final speedFactor = 0.5 + random.nextDouble() * 0.5;

          return Positioned(
            left: random.nextDouble() * 400,
            top:
                ((animationState.particleValue * 1000 * speedFactor) +
                    (random.nextDouble() * 600)) %
                600,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(width / 2),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAngryBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Red tint overlay
        Container(color: Colors.red.withOpacity(0.05)),

        // Lightning flashes
        ...List.generate(3, (index) {
          final random = Random(index);
          final size = 30.0 + random.nextDouble() * 20;

          return Positioned(
            left: random.nextDouble() * 400,
            top: random.nextDouble() * 600,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 50),
              opacity:
                  random.nextDouble() >
                          0.95 - (animationState.particleValue * 0.1)
                      ? 0.7
                      : 0.0,
              child: Icon(Icons.flash_on, color: Colors.yellow, size: size),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLovingBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Pink tint overlay
        Container(color: Colors.pink.withOpacity(0.05)),

        // Floating hearts
        ...List.generate(8, (index) {
          final random = Random(index);
          final size = 15.0 + random.nextDouble() * 20;
          final speedFactor = 0.2 + random.nextDouble() * 0.3;

          return Positioned(
            left: random.nextDouble() * 400,
            top:
                ((animationState.particleValue * -500 * speedFactor) +
                    (random.nextDouble() * 600)) %
                600,
            child: Transform.rotate(
              angle: random.nextDouble() * pi / 4 - pi / 8,
              child: Icon(
                Icons.favorite,
                color: Colors.pink.withOpacity(0.7),
                size: size,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSurprisedBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Quick flash effect on enter
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity:
              animationState.particleValue < 0.3
                  ? (0.3 - animationState.particleValue)
                  : 0.0,
          child: Container(color: Colors.white.withOpacity(0.3)),
        ),

        // Exclamation marks and question marks
        ...List.generate(5, (index) {
          final random = Random(index);
          final size = 20.0 + random.nextDouble() * 15;
          final isExclamation = random.nextBool();

          return Positioned(
            left: random.nextDouble() * 400,
            top: random.nextDouble() * 600,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity:
                  random.nextDouble() > animationState.particleValue
                      ? 0.7
                      : 0.0,
              child: Transform.rotate(
                angle: (random.nextDouble() * 0.4) - 0.2,
                child: Text(
                  isExclamation ? "!" : "?",
                  style: TextStyle(
                    color: isExclamation ? Colors.yellow : Colors.cyan,
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProcessingBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Tech-looking grid pattern
        CustomPaint(
          painter: GridPainter(
            color: themeData.accentColor.withOpacity(0.1),
            animationValue: animationState.particleValue,
          ),
          size: const Size(400, 600),
        ),

        // Data stream particles
        ...List.generate(10, (index) {
          final random = Random(index);
          final size = 8.0 + random.nextDouble() * 8;
          final speedFactor = 0.5 + random.nextDouble() * 0.5;
          final trackIndex = random.nextInt(5); // 5 tracks
          final trackWidth = 400 / 5;

          return Positioned(
            left: trackWidth * trackIndex + trackWidth / 2,
            top:
                ((animationState.particleValue * 1000 * speedFactor) +
                    (random.nextDouble() * 600)) %
                600,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: themeData.accentColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(size / 2),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildListeningBackgroundEffects(
    RobotThemeData themeData,
    EnhancedAnimationState animationState,
  ) {
    return Stack(
      children: [
        // Sound wave ripples
        ...List.generate(3, (index) {
          final random = Random(index);
          final phaseDiff = index / 3;
          final phase = (animationState.particleValue + phaseDiff) % 1.0;
          final size = 100.0 + phase * 200.0;
          final opacity = max(0, 1.0 - phase);

          return Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeData.accentColor.withOpacity(opacity * 0.5),
                  width: 2.0,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Custom painter for grid pattern
class GridPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  GridPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    final spacing = 30.0;
    for (double y = 0; y < size.height; y += spacing) {
      final animatedY = (y + animationValue * spacing) % size.height;
      canvas.drawLine(
        Offset(0, animatedY),
        Offset(size.width, animatedY),
        paint,
      );
    }

    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw data flow lines
    final flowPaint =
        Paint()
          ..color = color.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final random = Random(42); // Consistent seed for stable pattern

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = random.nextDouble() * size.width;

      path.moveTo(startX, 0);

      double currentX = startX;
      for (double y = 0; y < size.height; y += spacing) {
        // Random horizontal movement
        currentX += (random.nextDouble() - 0.5) * spacing * 2;
        currentX = currentX.clamp(0, size.width);

        path.lineTo(currentX, y);
      }

      // Animate dash pattern
      final dashPaint =
          Paint()
            ..color = color.withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final dashPattern = [15.0, 10.0];
      final dashOffset = DashPathEffect(
        dashPattern,
        animationValue * (dashPattern[0] + dashPattern[1]),
      );

      canvas.drawPath(dashOffset.apply(path), dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}

// Helper class for dash pattern effect
class DashPathEffect {
  final List<double> pattern;
  final double phase;

  DashPathEffect(this.pattern, this.phase);

  Path apply(Path source) {
    final Path dest = Path();
    final PathMetrics metrics = source.computeMetrics();

    for (PathMetric metric in metrics) {
      double distance = 0.0;
      bool draw = true;
      double patternLength = pattern.fold(0.0, (a, b) => a + b);
      double dashOffset = phase % patternLength;

      // Adjust starting position based on phase
      int patternIndex = 0;
      for (double startingPhase = dashOffset; startingPhase > 0;) {
        startingPhase -= pattern[patternIndex];
        if (startingPhase >= 0) {
          draw = !draw;
          patternIndex = (patternIndex + 1) % pattern.length;
        }
      }

      // First segment might be partial
      double currentDash = pattern[patternIndex];

      while (distance < metric.length) {
        final double segmentLength = min(currentDash, metric.length - distance);

        if (draw) {
          final Path extraction = metric.extractPath(
            distance,
            distance + segmentLength,
          );
          dest.addPath(extraction, Offset.zero);
        }

        distance += segmentLength;

        // Move to next dash/gap
        patternIndex = (patternIndex + 1) % pattern.length;
        currentDash = pattern[patternIndex];
        draw = !draw;
      }
    }

    return dest;
  }
}
