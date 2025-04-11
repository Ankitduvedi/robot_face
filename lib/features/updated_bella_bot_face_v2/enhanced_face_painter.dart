// lib/widgets/painters/enhanced_face_painters.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';

class EnhancedEyebrowPainter extends CustomPainter {
  final bool isLeft;
  final Offset offset;
  final CharacterSkin skin;
  final Color color;
  final double thickness;
  final bool isAnimated;
  final double animationValue;

  EnhancedEyebrowPainter({
    required this.isLeft,
    required this.offset,
    this.skin = CharacterSkin.robot,
    this.color = Colors.white,
    this.thickness = 12.0,
    this.isAnimated = false,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final double wHeight = size.height;
    final double wWidth = size.width;

    // Apply the offset to the eyebrow position with possible animation
    final verticalOffset =
        offset.dy + (isAnimated ? sin(animationValue * pi * 2) * 2 : 0);
    final horizontalOffset = offset.dx;

    // Adjust based on character skin
    switch (skin) {
      case CharacterSkin.cat:
        _drawCatEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.dog:
        _drawDogEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.alien:
        _drawAlienEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.panda:
        _drawPandaEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.underwater:
        _drawUnderwaterEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.space:
        _drawSpaceEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
      case CharacterSkin.robot:
      default:
        _drawDefaultEyebrow(
          canvas,
          path,
          wWidth,
          wHeight,
          horizontalOffset,
          verticalOffset,
          paint,
        );
        break;
    }
  }

  void _drawDefaultEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    if (isLeft) {
      path.moveTo(
        wWidth * 0.30 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.lineTo(
        wWidth * 0.37 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    } else {
      path.moveTo(
        wWidth * 0.63 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.lineTo(
        wWidth * 0.7 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    }

    canvas.drawPath(path, paint);
  }

  void _drawCatEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // More pointy, angled eyebrows for cat
    final startX = isLeft ? wWidth * 0.30 : wWidth * 0.63;
    final endX = isLeft ? wWidth * 0.37 : wWidth * 0.7;

    path.moveTo(startX + horizontalOffset, -wHeight * 5 + verticalOffset);
    path.lineTo(
      (startX + endX) / 2 + horizontalOffset,
      -wHeight * 5 + verticalOffset - 3.0,
    );
    path.lineTo(endX + horizontalOffset, -wHeight * 5 + verticalOffset);

    canvas.drawPath(path, paint);
  }

  void _drawDogEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // Softer, slightly curved eyebrows for dog
    if (isLeft) {
      path.moveTo(
        wWidth * 0.30 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.quadraticBezierTo(
        wWidth * 0.335 + horizontalOffset,
        -wHeight * 5 + verticalOffset - 2.0,
        wWidth * 0.37 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    } else {
      path.moveTo(
        wWidth * 0.63 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.quadraticBezierTo(
        wWidth * 0.665 + horizontalOffset,
        -wHeight * 5 + verticalOffset - 2.0,
        wWidth * 0.7 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    }

    canvas.drawPath(path, paint);
  }

  void _drawAlienEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // Very minimal, dot-like eyebrows for alien
    final centerX = isLeft ? wWidth * 0.335 : wWidth * 0.665;

    canvas.drawCircle(
      Offset(centerX + horizontalOffset, -wHeight * 5 + verticalOffset),
      3.0,
      paint..style = PaintingStyle.fill,
    );
  }

  void _drawPandaEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // Thick, rounded eyebrows for panda
    if (isLeft) {
      path.moveTo(
        wWidth * 0.29 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.lineTo(
        wWidth * 0.38 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    } else {
      path.moveTo(
        wWidth * 0.62 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.lineTo(
        wWidth * 0.71 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    }

    // Thicker stroke for panda
    paint.strokeWidth = thickness * 1.5;
    canvas.drawPath(path, paint);
  }

  void _drawUnderwaterEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // Curved, wave-like eyebrows for underwater
    if (isLeft) {
      path.moveTo(
        wWidth * 0.30 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.cubicTo(
        wWidth * 0.32 + horizontalOffset,
        -wHeight * 5 + verticalOffset - 2.0,
        wWidth * 0.35 + horizontalOffset,
        -wHeight * 5 + verticalOffset + 2.0,
        wWidth * 0.37 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    } else {
      path.moveTo(
        wWidth * 0.63 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
      path.cubicTo(
        wWidth * 0.65 + horizontalOffset,
        -wHeight * 5 + verticalOffset - 2.0,
        wWidth * 0.68 + horizontalOffset,
        -wHeight * 5 + verticalOffset + 2.0,
        wWidth * 0.7 + horizontalOffset,
        -wHeight * 5 + verticalOffset,
      );
    }

    canvas.drawPath(path, paint);
  }

  void _drawSpaceEyebrow(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double horizontalOffset,
    double verticalOffset,
    Paint paint,
  ) {
    // Segmented, tech-looking eyebrows for space theme
    final segments = 3;
    final startX = isLeft ? wWidth * 0.30 : wWidth * 0.63;
    final endX = isLeft ? wWidth * 0.37 : wWidth * 0.7;
    final segmentWidth = (endX - startX) / segments;

    for (int i = 0; i < segments; i++) {
      canvas.drawLine(
        Offset(
          startX + i * segmentWidth + horizontalOffset,
          -wHeight * 5 + verticalOffset,
        ),
        Offset(
          startX + (i + 0.7) * segmentWidth + horizontalOffset,
          -wHeight * 5 + verticalOffset,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedEyebrowPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        (isAnimated && oldDelegate.animationValue != animationValue);
  }
}

class EnhancedMouthPainter extends CustomPainter {
  final double curvature;
  final CharacterSkin skin;
  final Color color;
  final double animationValue;
  final bool isAnimated;
  final ExpressionType expressionType;

  EnhancedMouthPainter({
    required this.curvature,
    this.skin = CharacterSkin.robot,
    this.color = Colors.white,
    this.animationValue = 0.0,
    this.isAnimated = false,
    this.expressionType = ExpressionType.neutral,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 12.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final double wHeight = size.height;
    final double wWidth = size.width;

    // Apply animation if enabled
    double animatedCurvature = curvature;
    if (isAnimated) {
      // Apply subtle animation based on expression
      if (expressionType == ExpressionType.laughing ||
          expressionType == ExpressionType.excited) {
        // More pronounced animation for expressive mouths
        animatedCurvature += sin(animationValue * pi * 2) * 0.2;
      } else {
        // Subtle animation for other expressions
        animatedCurvature += sin(animationValue * pi * 2) * 0.05;
      }
    }

    // Draw mouth based on character skin
    switch (skin) {
      case CharacterSkin.cat:
        _drawCatMouth(canvas, path, wWidth, wHeight, animatedCurvature, paint);
        break;
      case CharacterSkin.dog:
        _drawDogMouth(canvas, path, wWidth, wHeight, animatedCurvature, paint);
        break;
      case CharacterSkin.alien:
        _drawAlienMouth(
          canvas,
          path,
          wWidth,
          wHeight,
          animatedCurvature,
          paint,
        );
        break;
      case CharacterSkin.panda:
        _drawPandaMouth(
          canvas,
          path,
          wWidth,
          wHeight,
          animatedCurvature,
          paint,
        );
        break;
      case CharacterSkin.underwater:
        _drawUnderwaterMouth(
          canvas,
          path,
          wWidth,
          wHeight,
          animatedCurvature,
          paint,
        );
        break;
      case CharacterSkin.space:
        _drawSpaceMouth(
          canvas,
          path,
          wWidth,
          wHeight,
          animatedCurvature,
          paint,
        );
        break;
      case CharacterSkin.robot:
      default:
        _drawDefaultMouth(
          canvas,
          path,
          wWidth,
          wHeight,
          animatedCurvature,
          paint,
        );
        break;
    }
  }

  void _drawDefaultMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Start point (left of mouth)
    path.moveTo(wWidth * 0.40, wHeight * 0.10);

    // Adjust control points based on curvature
    // Positive curvature = happy smile, negative = sad frown
    final double controlY = wHeight * 0.1 + (animatedCurvature * wHeight * 0.4);

    if (animatedCurvature.abs() < 0.1) {
      // Straight line for neutral
      path.arcToPoint(
        Offset(wWidth * 0.5, wHeight * 0.1),
        radius: const Radius.circular(10),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(wWidth * 0.6, wHeight * 0.1),
        radius: const Radius.circular(10),
        clockwise: false,
      );
    } else if (animatedCurvature > 0) {
      // Happy curved mouth (U shape)
      path.quadraticBezierTo(
        wWidth * 0.5,
        controlY,
        wWidth * 0.6,
        wHeight * 0.1,
      );
    } else {
      // Sad curved mouth (inverted U shape)
      path.quadraticBezierTo(
        wWidth * 0.5,
        controlY,
        wWidth * 0.6,
        wHeight * 0.1,
      );
    }

    canvas.drawPath(path, paint);

    // For more expressive mouths, add details
    if (expressionType == ExpressionType.laughing ||
        expressionType == ExpressionType.excited) {
      // Add teeth for laughing/excited
      if (animatedCurvature > 0.3) {
        final teethPath = Path();
        teethPath.moveTo(wWidth * 0.45, wHeight * 0.1);
        teethPath.lineTo(wWidth * 0.45, wHeight * 0.1 + animatedCurvature * 10);
        teethPath.moveTo(wWidth * 0.5, wHeight * 0.1);
        teethPath.lineTo(wWidth * 0.5, wHeight * 0.1 + animatedCurvature * 15);
        teethPath.moveTo(wWidth * 0.55, wHeight * 0.1);
        teethPath.lineTo(wWidth * 0.55, wHeight * 0.1 + animatedCurvature * 10);

        canvas.drawPath(teethPath, paint..strokeWidth = 4.0);
      }
    }
  }

  void _drawCatMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Cat-like mouth with small opening
    if (animatedCurvature > 0.2) {
      // Happy cat with W shape
      path.moveTo(wWidth * 0.40, wHeight * 0.10);
      path.lineTo(wWidth * 0.45, wHeight * 0.13);
      path.lineTo(wWidth * 0.5, wHeight * 0.10);
      path.lineTo(wWidth * 0.55, wHeight * 0.13);
      path.lineTo(wWidth * 0.6, wHeight * 0.10);
    } else if (animatedCurvature < -0.2) {
      // Sad cat
      path.moveTo(wWidth * 0.40, wHeight * 0.12);
      path.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.4),
        wWidth * 0.6,
        wHeight * 0.12,
      );
    } else {
      // Neutral cat - small line
      path.moveTo(wWidth * 0.45, wHeight * 0.10);
      path.lineTo(wWidth * 0.55, wHeight * 0.10);
    }

    canvas.drawPath(path, paint);
  }

  void _drawDogMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Dog-like mouth, more open and expressive
    if (animatedCurvature > 0.3) {
      // Happy dog with tongue
      // Mouth outline
      path.moveTo(wWidth * 0.40, wHeight * 0.10);
      path.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.5),
        wWidth * 0.6,
        wHeight * 0.10,
      );

      canvas.drawPath(path, paint);

      // Tongue
      final tonguePaint =
          Paint()
            ..color = Colors.pink
            ..style = PaintingStyle.fill;

      final tonguePath = Path();
      tonguePath.moveTo(
        wWidth * 0.48,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.3),
      );
      tonguePath.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.5),
        wWidth * 0.52,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.3),
      );
      tonguePath.lineTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.4),
      );
      tonguePath.close();

      canvas.drawPath(tonguePath, tonguePaint);
    } else {
      // Normal or sad dog
      path.moveTo(wWidth * 0.40, wHeight * 0.10);
      path.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.4),
        wWidth * 0.6,
        wHeight * 0.10,
      );

      canvas.drawPath(path, paint);
    }
  }

  void _drawAlienMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Alien mouth - more geometric
    if (animatedCurvature > 0.2) {
      // Happy alien - zigzag
      path.moveTo(wWidth * 0.40, wHeight * 0.10);
      for (int i = 0; i < 5; i++) {
        final x = wWidth * (0.40 + i * 0.05);
        final y = wHeight * 0.10 + (i.isEven ? 0 : animatedCurvature * 10);
        path.lineTo(x, y);
      }
    } else if (animatedCurvature < -0.2) {
      // Sad alien - broken line
      path.moveTo(wWidth * 0.40, wHeight * 0.08);
      path.lineTo(wWidth * 0.45, wHeight * 0.12);
      path.lineTo(wWidth * 0.5, wHeight * 0.08);
      path.lineTo(wWidth * 0.55, wHeight * 0.12);
      path.lineTo(wWidth * 0.6, wHeight * 0.08);
    } else {
      // Neutral alien - straight line with a dot
      path.moveTo(wWidth * 0.42, wHeight * 0.10);
      path.lineTo(wWidth * 0.58, wHeight * 0.10);

      // Add a central dot
      canvas.drawCircle(
        Offset(wWidth * 0.5, wHeight * 0.10),
        2.0,
        paint..style = PaintingStyle.fill,
      );
      paint.style = PaintingStyle.stroke;
    }

    canvas.drawPath(path, paint);
  }

  void _drawPandaMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Panda mouth - small and cute
    path.moveTo(wWidth * 0.45, wHeight * 0.10);

    if (animatedCurvature > 0.2) {
      // Happy panda - small curve
      path.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.2),
        wWidth * 0.55,
        wHeight * 0.10,
      );
    } else if (animatedCurvature < -0.2) {
      // Sad panda - small downward curve
      path.quadraticBezierTo(
        wWidth * 0.5,
        wHeight * 0.1 + (animatedCurvature * wHeight * 0.2),
        wWidth * 0.55,
        wHeight * 0.10,
      );
    } else {
      // Neutral panda - tiny line
      path.lineTo(wWidth * 0.55, wHeight * 0.10);
    }

    canvas.drawPath(path, paint);
  }

  void _drawUnderwaterMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Underwater mouth - bubble-like
    if (animatedCurvature > 0.2) {
      // Happy underwater - O shape
      canvas.drawCircle(
        Offset(wWidth * 0.5, wHeight * 0.1 + (animatedCurvature * 5)),
        8.0 + animatedCurvature * 5,
        paint,
      );
    } else if (animatedCurvature < -0.2) {
      // Sad underwater - flat oval
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(wWidth * 0.5, wHeight * 0.1),
          width: 20.0,
          height: 5.0 - animatedCurvature * 3,
        ),
        paint,
      );
    } else {
      // Neutral underwater - small circle
      canvas.drawCircle(Offset(wWidth * 0.5, wHeight * 0.1), 5.0, paint);
    }
  }

  void _drawSpaceMouth(
    Canvas canvas,
    Path path,
    double wWidth,
    double wHeight,
    double animatedCurvature,
    Paint paint,
  ) {
    // Space-themed mouth - LED-like display
    // Draw a series of segments like a digital display
    final segments = 5;
    final segmentWidth = wWidth * 0.04;

    if (animatedCurvature > 0.2) {
      // Happy space - upward curve of segments
      for (int i = 0; i < segments; i++) {
        final x = wWidth * (0.4 + i * 0.05);
        final y =
            wHeight * 0.1 +
            sin(i / (segments - 1) * pi) * animatedCurvature * 10;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: segmentWidth,
            height: 4.0,
          ),
          paint..style = PaintingStyle.fill,
        );
      }
    } else if (animatedCurvature < -0.2) {
      // Sad space - downward curve of segments
      for (int i = 0; i < segments; i++) {
        final x = wWidth * (0.4 + i * 0.05);
        final y =
            wHeight * 0.1 +
            sin((i / (segments - 1) * pi) + pi) * animatedCurvature * -10;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: segmentWidth,
            height: 4.0,
          ),
          paint..style = PaintingStyle.fill,
        );
      }
    } else {
      // Neutral space - straight line of segments
      for (int i = 0; i < segments; i++) {
        final x = wWidth * (0.4 + i * 0.05);

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, wHeight * 0.1),
            width: segmentWidth,
            height: 4.0,
          ),
          paint..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedMouthPainter oldDelegate) {
    return oldDelegate.curvature != curvature ||
        oldDelegate.color != color ||
        oldDelegate.skin != skin ||
        (isAnimated && oldDelegate.animationValue != animationValue);
  }
}

class BlushPainter extends CustomPainter {
  final Color color;
  final double size;
  final CharacterSkin skin;
  final double animationValue;
  final bool isAnimated;

  BlushPainter({
    this.color = Colors.pink,
    this.size = 1.0,
    this.skin = CharacterSkin.robot,
    this.animationValue = 0.0,
    this.isAnimated = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Use different blush styles based on character skin
    switch (skin) {
      case CharacterSkin.cat:
        _drawCatBlush(canvas, size);
        break;
      case CharacterSkin.dog:
        _drawDogBlush(canvas, size);
        break;
      case CharacterSkin.alien:
        _drawAlienBlush(canvas, size);
        break;
      case CharacterSkin.panda:
        _drawPandaBlush(canvas, size);
        break;
      case CharacterSkin.underwater:
        _drawUnderwaterBlush(canvas, size);
        break;
      case CharacterSkin.space:
        _drawSpaceBlush(canvas, size);
        break;
      case CharacterSkin.robot:
      default:
        _drawDefaultBlush(canvas, size);
        break;
    }
  }

  void _drawDefaultBlush(Canvas canvas, Size canvasSize) {
    // Basic circle blush
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.3 + (sin(animationValue * pi) * 0.2) : 0.3,
          )
          ..style = PaintingStyle.fill;

    final leftCenter = Offset(canvasSize.width * 0.3, canvasSize.height * 0.5);
    final rightCenter = Offset(canvasSize.width * 0.7, canvasSize.height * 0.5);
    final radius = canvasSize.width * 0.12 * this.size;

    canvas.drawCircle(leftCenter, radius, paint);
    canvas.drawCircle(rightCenter, radius, paint);
  }

  void _drawCatBlush(Canvas canvas, Size canvasSize) {
    // Small oval blush for cat
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.3 + (sin(animationValue * pi) * 0.2) : 0.3,
          )
          ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(canvasSize.width * 0.3, canvasSize.height * 0.5),
        width: canvasSize.width * 0.15 * this.size,
        height: canvasSize.width * 0.08 * this.size,
      ),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(canvasSize.width * 0.7, canvasSize.height * 0.5),
        width: canvasSize.width * 0.15 * this.size,
        height: canvasSize.width * 0.08 * this.size,
      ),
      paint,
    );
  }

  void _drawDogBlush(Canvas canvas, Size canvasSize) {
    // Larger, more spread out blush for dog
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.2 + (sin(animationValue * pi) * 0.1) : 0.2,
          )
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(canvasSize.width * 0.28, canvasSize.height * 0.52),
      canvasSize.width * 0.13 * this.size,
      paint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.72, canvasSize.height * 0.52),
      canvasSize.width * 0.13 * this.size,
      paint,
    );
  }

  void _drawAlienBlush(Canvas canvas, Size canvasSize) {
    // Alien blush with geometric pattern
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.4 + (sin(animationValue * pi) * 0.3) : 0.4,
          )
          ..style = PaintingStyle.fill;

    // Draw triangular blush
    final leftPath = Path();
    leftPath.moveTo(canvasSize.width * 0.25, canvasSize.height * 0.48);
    leftPath.lineTo(canvasSize.width * 0.35, canvasSize.height * 0.48);
    leftPath.lineTo(canvasSize.width * 0.3, canvasSize.height * 0.53);
    leftPath.close();

    final rightPath = Path();
    rightPath.moveTo(canvasSize.width * 0.65, canvasSize.height * 0.48);
    rightPath.lineTo(canvasSize.width * 0.75, canvasSize.height * 0.48);
    rightPath.lineTo(canvasSize.width * 0.7, canvasSize.height * 0.53);
    rightPath.close();

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);
  }

  void _drawPandaBlush(Canvas canvas, Size canvasSize) {
    // Subtle round blush for panda
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.15 + (sin(animationValue * pi) * 0.05) : 0.15,
          )
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(canvasSize.width * 0.3, canvasSize.height * 0.5),
      canvasSize.width * 0.1 * this.size,
      paint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.7, canvasSize.height * 0.5),
      canvasSize.width * 0.1 * this.size,
      paint,
    );
  }

  void _drawUnderwaterBlush(Canvas canvas, Size canvasSize) {
    // Bubble-like blush for underwater
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.3 + (sin(animationValue * pi) * 0.2) : 0.3,
          )
          ..style = PaintingStyle.fill;

    final bubblePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    // Main blush
    canvas.drawCircle(
      Offset(canvasSize.width * 0.3, canvasSize.height * 0.5),
      canvasSize.width * 0.11 * this.size,
      paint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.7, canvasSize.height * 0.5),
      canvasSize.width * 0.11 * this.size,
      paint,
    );

    // Small highlight bubbles
    canvas.drawCircle(
      Offset(canvasSize.width * 0.27, canvasSize.height * 0.47),
      canvasSize.width * 0.02 * this.size,
      bubblePaint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.67, canvasSize.height * 0.47),
      canvasSize.width * 0.02 * this.size,
      bubblePaint,
    );
  }

  void _drawSpaceBlush(Canvas canvas, Size canvasSize) {
    // Tech-looking blush for space theme
    final paint =
        Paint()
          ..color = color.withOpacity(
            isAnimated ? 0.3 + (sin(animationValue * pi) * 0.2) : 0.3,
          )
          ..style = PaintingStyle.fill;

    // Left hexagonal blush
    final leftPath = Path();
    final leftCenter = Offset(canvasSize.width * 0.3, canvasSize.height * 0.5);
    final leftSize = canvasSize.width * 0.08 * this.size;

    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final point = Offset(
        leftCenter.dx + cos(angle) * leftSize,
        leftCenter.dy + sin(angle) * leftSize,
      );

      if (i == 0) {
        leftPath.moveTo(point.dx, point.dy);
      } else {
        leftPath.lineTo(point.dx, point.dy);
      }
    }
    leftPath.close();

    // Right hexagonal blush
    final rightPath = Path();
    final rightCenter = Offset(canvasSize.width * 0.7, canvasSize.height * 0.5);
    final rightSize = canvasSize.width * 0.08 * this.size;

    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final point = Offset(
        rightCenter.dx + cos(angle) * rightSize,
        rightCenter.dy + sin(angle) * rightSize,
      );

      if (i == 0) {
        rightPath.moveTo(point.dx, point.dy);
      } else {
        rightPath.lineTo(point.dx, point.dy);
      }
    }
    rightPath.close();

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant BlushPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.size != size ||
        oldDelegate.skin != skin ||
        (isAnimated && oldDelegate.animationValue != animationValue);
  }
}

class GlowPainter extends CustomPainter {
  final Color color;
  final double intensity;
  final double animationValue;

  GlowPainter({
    required this.color,
    required this.intensity,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    // Calculate actual intensity with pulsing effect
    final pulseFactor = (1.0 + sin(animationValue * pi * 2) * 0.2);
    final actualIntensity = intensity * pulseFactor;

    // Create radial gradient for glow effect
    final paint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withOpacity(0.5 * actualIntensity),
              color.withOpacity(0.3 * actualIntensity),
              color.withOpacity(0.1 * actualIntensity),
              color.withOpacity(0.0),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    // Draw glow circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.6, // Glow extends beyond the face
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.intensity != intensity ||
        oldDelegate.animationValue != animationValue;
  }
}

class AccessoryPainter extends CustomPainter {
  final AccessoryType accessory;
  final double size;
  final Color color;
  final Color accentColor;
  final double animationValue;

  AccessoryPainter({
    required this.accessory,
    this.size = 1.0,
    required this.color,
    required this.accentColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (accessory == AccessoryType.none) return;

    switch (accessory) {
      case AccessoryType.glasses:
        _drawGlasses(canvas, canvasSize);
        break;
      case AccessoryType.hat:
        _drawHat(canvas, canvasSize);
        break;
      case AccessoryType.bowtie:
        _drawBowtie(canvas, canvasSize);
        break;
      case AccessoryType.headphones:
        _drawHeadphones(canvas, canvasSize);
        break;
      case AccessoryType.crown:
        _drawCrown(canvas, canvasSize);
        break;
      case AccessoryType.flower:
        _drawFlower(canvas, canvasSize);
        break;
      case AccessoryType.antenna:
        _drawAntenna(canvas, canvasSize);
        break;
      case AccessoryType.bandana:
        _drawBandana(canvas, canvasSize);
        break;
      default:
        break;
    }
  }

  void _drawGlasses(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * size;

    // Left lens
    canvas.drawCircle(
      Offset(canvasSize.width * 0.35, canvasSize.height * 0.3),
      canvasSize.width * 0.15 * size,
      paint,
    );

    // Right lens
    canvas.drawCircle(
      Offset(canvasSize.width * 0.65, canvasSize.height * 0.3),
      canvasSize.width * 0.15 * size,
      paint,
    );

    // Bridge
    canvas.drawLine(
      Offset(canvasSize.width * 0.42, canvasSize.height * 0.3),
      Offset(canvasSize.width * 0.58, canvasSize.height * 0.3),
      paint,
    );

    // Temple arms
    canvas.drawLine(
      Offset(canvasSize.width * 0.2, canvasSize.height * 0.3),
      Offset(canvasSize.width * 0.15, canvasSize.height * 0.25),
      paint,
    );

    canvas.drawLine(
      Offset(canvasSize.width * 0.8, canvasSize.height * 0.3),
      Offset(canvasSize.width * 0.85, canvasSize.height * 0.25),
      paint,
    );
  }

  void _drawHat(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final accentPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Hat body (beanie style)
    final hatPath = Path();
    hatPath.moveTo(canvasSize.width * 0.2, canvasSize.height * 0.15);
    hatPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.0,
      canvasSize.width * 0.8,
      canvasSize.height * 0.15,
    );
    hatPath.lineTo(canvasSize.width * 0.8, canvasSize.height * 0.25);
    hatPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.35,
      canvasSize.width * 0.2,
      canvasSize.height * 0.25,
    );
    hatPath.close();

    // Add slight bobbing animation
    canvas.save();
    canvas.translate(0, sin(animationValue * pi * 2) * 2);

    canvas.drawPath(hatPath, paint);

    // Hat band
    final bandPath = Path();
    bandPath.moveTo(canvasSize.width * 0.2, canvasSize.height * 0.24);
    bandPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.34,
      canvasSize.width * 0.8,
      canvasSize.height * 0.24,
    );
    bandPath.lineTo(canvasSize.width * 0.8, canvasSize.height * 0.26);
    bandPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.36,
      canvasSize.width * 0.2,
      canvasSize.height * 0.26,
    );
    bandPath.close();

    canvas.drawPath(bandPath, accentPaint);

    // Pom-pom on top
    canvas.drawCircle(
      Offset(canvasSize.width * 0.5, canvasSize.height * 0.08),
      canvasSize.width * 0.05,
      accentPaint,
    );

    canvas.restore();
  }

  void _drawBowtie(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final centerPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Slight animation
    final scale = 1.0 + sin(animationValue * pi * 2) * 0.05;

    canvas.save();
    canvas.translate(canvasSize.width * 0.5, canvasSize.height * 0.7);
    canvas.scale(scale, scale);

    // Left triangle
    final leftPath = Path();
    leftPath.moveTo(-canvasSize.width * 0.15, -canvasSize.height * 0.05);
    leftPath.lineTo(-canvasSize.width * 0.05, 0);
    leftPath.lineTo(-canvasSize.width * 0.15, canvasSize.height * 0.05);
    leftPath.close();

    // Right triangle
    final rightPath = Path();
    rightPath.moveTo(canvasSize.width * 0.15, -canvasSize.height * 0.05);
    rightPath.lineTo(canvasSize.width * 0.05, 0);
    rightPath.lineTo(canvasSize.width * 0.15, canvasSize.height * 0.05);
    rightPath.close();

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);

    // Center knot
    canvas.drawCircle(Offset.zero, canvasSize.width * 0.03, centerPaint);

    canvas.restore();
  }

  void _drawHeadphones(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final accentPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Headphone band
    final bandPath = Path();
    bandPath.moveTo(canvasSize.width * 0.2, canvasSize.height * 0.3);
    bandPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.1,
      canvasSize.width * 0.8,
      canvasSize.height * 0.3,
    );

    canvas.drawPath(
      bandPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * size,
    );

    // Left ear cup with subtle animation
    final leftOffset = sin(animationValue * pi * 2) * 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            canvasSize.width * 0.2,
            canvasSize.height * 0.3 + leftOffset,
          ),
          width: canvasSize.width * 0.12,
          height: canvasSize.height * 0.15,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    // Right ear cup with subtle animation
    final rightOffset = sin((animationValue + 0.5) * pi * 2) * 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            canvasSize.width * 0.8,
            canvasSize.height * 0.3 + rightOffset,
          ),
          width: canvasSize.width * 0.12,
          height: canvasSize.height * 0.15,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    // Ear cushions
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            canvasSize.width * 0.2,
            canvasSize.height * 0.3 + leftOffset,
          ),
          width: canvasSize.width * 0.08,
          height: canvasSize.height * 0.11,
        ),
        const Radius.circular(8),
      ),
      accentPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            canvasSize.width * 0.8,
            canvasSize.height * 0.3 + rightOffset,
          ),
          width: canvasSize.width * 0.08,
          height: canvasSize.height * 0.11,
        ),
        const Radius.circular(8),
      ),
      accentPaint,
    );
  }

  void _drawCrown(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final accentPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Crown with subtle bobbing animation
    canvas.save();
    canvas.translate(0, sin(animationValue * pi * 2) * 2);

    // Base crown shape
    final crownPath = Path();
    crownPath.moveTo(canvasSize.width * 0.2, canvasSize.height * 0.2);
    crownPath.lineTo(canvasSize.width * 0.3, canvasSize.height * 0.1);
    crownPath.lineTo(canvasSize.width * 0.4, canvasSize.height * 0.2);
    crownPath.lineTo(canvasSize.width * 0.5, canvasSize.height * 0.05);
    crownPath.lineTo(canvasSize.width * 0.6, canvasSize.height * 0.2);
    crownPath.lineTo(canvasSize.width * 0.7, canvasSize.height * 0.1);
    crownPath.lineTo(canvasSize.width * 0.8, canvasSize.height * 0.2);
    crownPath.lineTo(canvasSize.width * 0.8, canvasSize.height * 0.28);
    crownPath.quadraticBezierTo(
      canvasSize.width * 0.5,
      canvasSize.height * 0.35,
      canvasSize.width * 0.2,
      canvasSize.height * 0.28,
    );
    crownPath.close();

    canvas.drawPath(crownPath, paint);

    // Gems on the crown
    canvas.drawCircle(
      Offset(canvasSize.width * 0.3, canvasSize.height * 0.15),
      canvasSize.width * 0.03,
      accentPaint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.5, canvasSize.height * 0.11),
      canvasSize.width * 0.04,
      accentPaint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.7, canvasSize.height * 0.15),
      canvasSize.width * 0.03,
      accentPaint,
    );

    canvas.restore();
  }

  void _drawFlower(Canvas canvas, Size canvasSize) {
    final petalPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final centerPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Position on the side of head with slight animation
    final angle = animationValue * pi * 2;
    canvas.save();
    canvas.translate(
      canvasSize.width * 0.2,
      canvasSize.height * 0.2 + sin(angle) * 2,
    );
    canvas.rotate(sin(angle * 0.5) * 0.1); // Gentle swaying

    // Draw petals
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * pi / 4);

      final petalPath = Path();
      petalPath.moveTo(0, 0);
      petalPath.quadraticBezierTo(
        canvasSize.width * 0.06,
        -canvasSize.width * 0.02,
        canvasSize.width * 0.08,
        -canvasSize.width * 0.08,
      );
      petalPath.quadraticBezierTo(
        canvasSize.width * 0.1,
        -canvasSize.width * 0.02,
        0,
        0,
      );

      canvas.drawPath(petalPath, petalPaint);
      canvas.restore();
    }

    // Draw center
    canvas.drawCircle(Offset.zero, canvasSize.width * 0.03, centerPaint);

    canvas.restore();
  }

  void _drawAntenna(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * size
          ..strokeCap = StrokeCap.round;

    final ballPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Draw two antenna with bouncing animation
    final leftWobble = sin(animationValue * pi * 2) * 5;
    final rightWobble = sin((animationValue + 0.5) * pi * 2) * 5;

    // Left antenna
    final leftPath = Path();
    leftPath.moveTo(canvasSize.width * 0.35, canvasSize.height * 0.1);
    leftPath.quadraticBezierTo(
      canvasSize.width * 0.3 + leftWobble,
      -canvasSize.height * 0.1,
      canvasSize.width * 0.2,
      -canvasSize.height * 0.05,
    );

    // Right antenna
    final rightPath = Path();
    rightPath.moveTo(canvasSize.width * 0.65, canvasSize.height * 0.1);
    rightPath.quadraticBezierTo(
      canvasSize.width * 0.7 + rightWobble,
      -canvasSize.height * 0.1,
      canvasSize.width * 0.8,
      -canvasSize.height * 0.05,
    );

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);

    // Balls at the end of antenna
    canvas.drawCircle(
      Offset(canvasSize.width * 0.2, -canvasSize.height * 0.05),
      canvasSize.width * 0.03,
      ballPaint,
    );

    canvas.drawCircle(
      Offset(canvasSize.width * 0.8, -canvasSize.height * 0.05),
      canvasSize.width * 0.03,
      ballPaint,
    );
  }

  void _drawBandana(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final patternPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    // Bandana with slight animation
    canvas.save();
    canvas.translate(0, sin(animationValue * pi * 2) * 1);

    // Main bandana
    final bandanaPath = Path();
    bandanaPath.moveTo(canvasSize.width * 0.1, canvasSize.height * 0.2);
    bandanaPath.lineTo(canvasSize.width * 0.9, canvasSize.height * 0.2);
    bandanaPath.lineTo(canvasSize.width * 0.9, canvasSize.height * 0.27);
    bandanaPath.lineTo(canvasSize.width * 0.1, canvasSize.height * 0.27);
    bandanaPath.close();

    canvas.drawPath(bandanaPath, paint);

    // Pattern (polka dots)
    for (int i = 0; i < 8; i++) {
      canvas.drawCircle(
        Offset(canvasSize.width * (0.15 + i * 0.1), canvasSize.height * 0.235),
        canvasSize.width * 0.01,
        patternPaint,
      );
    }

    // Knot at back
    final knotPath = Path();
    knotPath.moveTo(canvasSize.width * 0.85, canvasSize.height * 0.22);
    knotPath.lineTo(canvasSize.width * 0.95, canvasSize.height * 0.18);
    knotPath.lineTo(canvasSize.width * 0.95, canvasSize.height * 0.29);
    knotPath.lineTo(canvasSize.width * 0.85, canvasSize.height * 0.25);
    knotPath.close();

    canvas.drawPath(knotPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AccessoryPainter oldDelegate) {
    return oldDelegate.accessory != accessory ||
        oldDelegate.size != size ||
        oldDelegate.color != color ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.animationValue != animationValue;
  }
}
