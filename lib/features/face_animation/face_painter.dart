// widgets/painters/face_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot_display_v2/features/face_animation/face_modal.dart';

class FacePainter extends CustomPainter {
  final FaceExpression expression;
  final AnimationController blinkController;
  final bool isBlinking;

  FacePainter({
    required this.expression,
    required this.blinkController,
    required this.isBlinking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw eyebrows
    _drawEyebrows(canvas, center, radius);

    // Draw eyes
    _drawEyes(canvas, center, radius);

    // Draw mouth
    _drawMouth(canvas, center, radius);

    // Draw special features
    _drawSpecialFeatures(canvas, center, radius);
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03
          ..strokeCap = StrokeCap.round;

    // Left eyebrow
    final leftEyebrowStart = Offset(
      center.dx + expression.leftEyebrowPositions[0].dx * radius,
      center.dy + expression.leftEyebrowPositions[0].dy * radius,
    );
    final leftEyebrowEnd = Offset(
      center.dx + expression.leftEyebrowPositions[1].dx * radius,
      center.dy + expression.leftEyebrowPositions[1].dy * radius,
    );

    // Draw curved left eyebrow
    final leftEyebrowPath = Path();
    leftEyebrowPath.moveTo(leftEyebrowStart.dx, leftEyebrowStart.dy);

    // Control point Y position for curve
    double leftControlPointY;

    // Determine control point y-position based on expression type
    switch (expression.type) {
      case ExpressionType.angry:
        leftControlPointY =
            leftEyebrowStart.dy +
            (leftEyebrowEnd.dy - leftEyebrowStart.dy) * 0.5;
        break;
      case ExpressionType.sad:
      case ExpressionType.worried:
      case ExpressionType.crying:
        leftControlPointY =
            leftEyebrowStart.dy -
            (leftEyebrowStart.dy - leftEyebrowEnd.dy) * 0.5;
        break;
      case ExpressionType.surprised:
        leftControlPointY =
            min(leftEyebrowStart.dy, leftEyebrowEnd.dy) - radius * 0.05;
        break;
      default:
        // For most expressions, slight arch upward like in the reference image
        leftControlPointY =
            min(leftEyebrowStart.dy, leftEyebrowEnd.dy) - radius * 0.03;
    }

    leftEyebrowPath.quadraticBezierTo(
      (leftEyebrowStart.dx + leftEyebrowEnd.dx) / 2,
      leftControlPointY,
      leftEyebrowEnd.dx,
      leftEyebrowEnd.dy,
    );

    canvas.drawPath(leftEyebrowPath, paint);

    // Right eyebrow
    final rightEyebrowStart = Offset(
      center.dx + expression.rightEyebrowPositions[0].dx * radius,
      center.dy + expression.rightEyebrowPositions[0].dy * radius,
    );
    final rightEyebrowEnd = Offset(
      center.dx + expression.rightEyebrowPositions[1].dx * radius,
      center.dy + expression.rightEyebrowPositions[1].dy * radius,
    );

    // Draw curved right eyebrow
    final rightEyebrowPath = Path();
    rightEyebrowPath.moveTo(rightEyebrowStart.dx, rightEyebrowStart.dy);

    // Control point Y position for curve
    double rightControlPointY;

    // Determine control point y-position based on expression type
    switch (expression.type) {
      case ExpressionType.angry:
        rightControlPointY =
            rightEyebrowStart.dy +
            (rightEyebrowEnd.dy - rightEyebrowStart.dy) * 0.5;
        break;
      case ExpressionType.sad:
      case ExpressionType.worried:
      case ExpressionType.crying:
        rightControlPointY =
            rightEyebrowStart.dy -
            (rightEyebrowStart.dy - rightEyebrowEnd.dy) * 0.5;
        break;
      case ExpressionType.surprised:
        rightControlPointY =
            min(rightEyebrowStart.dy, rightEyebrowEnd.dy) - radius * 0.05;
        break;
      default:
        // For most expressions, slight arch upward like in the reference image
        rightControlPointY =
            min(rightEyebrowStart.dy, rightEyebrowEnd.dy) - radius * 0.03;
    }

    rightEyebrowPath.quadraticBezierTo(
      (rightEyebrowStart.dx + rightEyebrowEnd.dx) / 2,
      rightControlPointY,
      rightEyebrowEnd.dx,
      rightEyebrowEnd.dy,
    );

    canvas.drawPath(rightEyebrowPath, paint);
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeStrokePaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.02;

    final eyeFillPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final pupilPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Handle special case for Dead expression with X eyes
    if (expression.type == ExpressionType.dead) {
      _drawXEyes(canvas, center, radius);
      return;
    }

    // Handle special case for Love expression with heart eyes
    if (expression.type == ExpressionType.love) {
      _drawHeartEyes(canvas, center, radius);
      return;
    }

    double blinkValue = isBlinking ? blinkController.value : 0.0;

    // For sleepy expression, draw curved closed eyes
    if (expression.type == ExpressionType.sleepy) {
      final eyeStrokePaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.03
            ..strokeCap = StrokeCap.round;

      // Left eye - more curved line
      final leftEyeStart = Offset(
        center.dx + expression.leftEyePositions[0].dx * radius,
        center.dy + expression.leftEyePositions[0].dy * radius,
      );
      final leftEyeEnd = Offset(
        center.dx + expression.leftEyePositions[1].dx * radius,
        center.dy + expression.leftEyePositions[1].dy * radius,
      );

      final leftEyePath = Path();
      leftEyePath.moveTo(leftEyeStart.dx, leftEyeStart.dy);

      // More pronounced curve for cuter appearance
      leftEyePath.quadraticBezierTo(
        (leftEyeStart.dx + leftEyeEnd.dx) / 2,
        leftEyeStart.dy + radius * 0.05, // Deeper curve
        leftEyeEnd.dx,
        leftEyeEnd.dy,
      );

      canvas.drawPath(leftEyePath, eyeStrokePaint);

      // Right eye - more curved line
      final rightEyeStart = Offset(
        center.dx + expression.rightEyePositions[0].dx * radius,
        center.dy + expression.rightEyePositions[0].dy * radius,
      );
      final rightEyeEnd = Offset(
        center.dx + expression.rightEyePositions[1].dx * radius,
        center.dy + expression.rightEyePositions[1].dy * radius,
      );

      final rightEyePath = Path();
      rightEyePath.moveTo(rightEyeStart.dx, rightEyeStart.dy);

      // More pronounced curve for cuter appearance
      rightEyePath.quadraticBezierTo(
        (rightEyeStart.dx + rightEyeEnd.dx) / 2,
        rightEyeStart.dy + radius * 0.05, // Deeper curve
        rightEyeEnd.dx,
        rightEyeEnd.dy,
      );

      canvas.drawPath(rightEyePath, eyeStrokePaint);
    }

    // Left eye
    if (expression.type != ExpressionType.wink) {
      _drawSingleEye(
        canvas,
        center,
        radius,
        expression.leftEyePositions,
        expression.hasLeftPupil,
        expression.leftPupilScale,
        eyeStrokePaint,
        eyeFillPaint,
        pupilPaint,
        blinkValue,
        true,
      );
    } else {
      // For wink, left eye is open
      _drawSingleEye(
        canvas,
        center,
        radius,
        expression.leftEyePositions,
        expression.hasLeftPupil,
        expression.leftPupilScale,
        eyeStrokePaint,
        eyeFillPaint,
        pupilPaint,
        0.0,
        true,
      );
    }

    // Right eye
    if (expression.type == ExpressionType.wink) {
      // Draw closed right eye for wink
      final rightEyeStart = Offset(
        center.dx + expression.rightEyePositions[0].dx * radius,
        center.dy + expression.rightEyePositions[0].dy * radius,
      );
      final rightEyeEnd = Offset(
        center.dx + expression.rightEyePositions[1].dx * radius,
        center.dy + expression.rightEyePositions[1].dy * radius,
      );

      canvas.drawLine(
        rightEyeStart,
        rightEyeEnd,
        eyeStrokePaint..strokeWidth = radius * 0.04,
      );
    } else {
      _drawSingleEye(
        canvas,
        center,
        radius,
        expression.rightEyePositions,
        expression.hasRightPupil,
        expression.rightPupilScale,
        eyeStrokePaint,
        eyeFillPaint,
        pupilPaint,
        blinkValue,
        false,
      );
    }

    // For eye roll, position pupils differently
    if (expression.type == ExpressionType.eyeRoll) {
      final leftPupilCenter = Offset(
        center.dx + expression.extraFeaturePositions[0].dx * radius,
        center.dy + expression.extraFeaturePositions[0].dy * radius,
      );

      final rightPupilCenter = Offset(
        center.dx + expression.extraFeaturePositions[1].dx * radius,
        center.dy + expression.extraFeaturePositions[1].dy * radius,
      );

      canvas.drawCircle(leftPupilCenter, radius * 0.05, pupilPaint);
      canvas.drawCircle(rightPupilCenter, radius * 0.05, pupilPaint);
    }
  }

  void _drawSingleEye(
    Canvas canvas,
    Offset center,
    double radius,
    List<Offset> eyePositions,
    bool hasPupil,
    double pupilScale,
    Paint strokePaint,
    Paint fillPaint,
    Paint pupilPaint,
    double blinkValue,
    bool isLeftEye,
  ) {
    if (eyePositions.length < 2) return;

    // For fully closed or winking eye
    if (blinkValue >= 0.9 ||
        (expression.type == ExpressionType.wink && !isLeftEye)) {
      // Use curved line for closed eye (more anime-like, matching the image)
      final eyeStart = Offset(
        center.dx + eyePositions[0].dx * radius,
        center.dy + eyePositions[0].dy * radius,
      );
      final eyeEnd = Offset(
        center.dx + eyePositions[1].dx * radius,
        center.dy + eyePositions[1].dy * radius,
      );

      final closedEyePath = Path();
      closedEyePath.moveTo(eyeStart.dx, eyeStart.dy);
      closedEyePath.quadraticBezierTo(
        (eyeStart.dx + eyeEnd.dx) / 2,
        eyeStart.dy - radius * 0.03, // Curve slightly upward
        eyeEnd.dx,
        eyeEnd.dy,
      );

      canvas.drawPath(closedEyePath, strokePaint..strokeWidth = radius * 0.03);
      return;
    }

    // For sleepy or similar expressions - draw curved eyes
    if ((expression.type == ExpressionType.sleepy ||
            expression.type == ExpressionType.cute ||
            expression.type == ExpressionType.happy ||
            expression.type == ExpressionType.laughing) &&
        blinkValue < 0.9) {
      final eyeStart = Offset(
        center.dx + eyePositions[0].dx * radius,
        center.dy + eyePositions[0].dy * radius,
      );
      final eyeEnd = Offset(
        center.dx + eyePositions[1].dx * radius,
        center.dy + eyePositions[1].dy * radius,
      );

      // Draw curved eye (upside-down U shape like in the image)
      final curvePath = Path();
      curvePath.moveTo(eyeStart.dx, eyeStart.dy);

      // Different curve directions for different expressions
      final curveDirection =
          expression.type == ExpressionType.sad ||
                  expression.type == ExpressionType.crying
              ? 0.03
              : -0.03;

      curvePath.quadraticBezierTo(
        (eyeStart.dx + eyeEnd.dx) / 2,
        eyeStart.dy + radius * curveDirection,
        eyeEnd.dx,
        eyeEnd.dy,
      );

      canvas.drawPath(curvePath, strokePaint..strokeWidth = radius * 0.03);

      // For some expressions, add additional details
      if (expression.type == ExpressionType.cute ||
          expression.type == ExpressionType.happy ||
          expression.type == ExpressionType.laughing) {
        // Small curve below the eye for cute/happy look
        final secondCurvePath = Path();
        secondCurvePath.moveTo(
          eyeStart.dx + (eyeEnd.dx - eyeStart.dx) * 0.2,
          eyeStart.dy + radius * 0.04,
        );
        secondCurvePath.quadraticBezierTo(
          (eyeStart.dx + eyeEnd.dx) / 2,
          eyeStart.dy + radius * 0.01,
          eyeEnd.dx - (eyeEnd.dx - eyeStart.dx) * 0.2,
          eyeEnd.dy + radius * 0.04,
        );

        canvas.drawPath(
          secondCurvePath,
          strokePaint..strokeWidth = radius * 0.02,
        );
      }

      return;
    }

    // Draw circle-shaped eyes for most expressions (like in the provided image)
    final eyeCenter = Offset(
      center.dx + (eyePositions[0].dx + eyePositions[1].dx) / 2 * radius,
      center.dy + (eyePositions[0].dy + eyePositions[1].dy) / 2 * radius,
    );

    // Make eye diameter smaller
    final eyeDiameter =
        (eyePositions[1].dx - eyePositions[0].dx).abs() *
        radius *
        0.6; // Reduced from 0.8 to 0.6

    // For surprised expression, make eyes bigger but still proportionate
    final eyeSize =
        expression.type == ExpressionType.surprised
            ? eyeDiameter *
                1.2 // Reduced from 1.3 to 1.2
            : eyeDiameter;

    // Draw white of eye
    canvas.drawCircle(eyeCenter, eyeSize, fillPaint);
    canvas.drawCircle(eyeCenter, eyeSize, strokePaint);

    // Draw pupil if needed
    if (hasPupil && blinkValue < 0.7) {
      final pupilRadius = eyeSize * 0.4 * pupilScale;

      // For some expressions, adjust pupil position
      Offset pupilOffset = Offset.zero;

      // Adjust pupil position for specific expressions
      switch (expression.type) {
        case ExpressionType.thinking:
          pupilOffset =
              isLeftEye
                  ? Offset(-pupilRadius * 0.5, 0)
                  : Offset(pupilRadius * 0.5, 0);
          break;
        case ExpressionType.confused:
          pupilOffset =
              isLeftEye
                  ? Offset(-pupilRadius * 0.3, pupilRadius * 0.3)
                  : Offset(pupilRadius * 0.6, -pupilRadius * 0.3);
          break;
        case ExpressionType.eyeRoll:
          // Skip pupil as we draw it elsewhere
          return;
        case ExpressionType.angry:
          pupilOffset = Offset(
            isLeftEye ? -pupilRadius * 0.3 : pupilRadius * 0.3,
            pupilRadius * 0.4,
          );
          break;
        case ExpressionType.sad:
        case ExpressionType.crying:
          pupilOffset = Offset(0, pupilRadius * 0.3);
          break;
        default:
          break;
      }

      // Draw pupil - make it a bit smaller and more centered, like in the image
      canvas.drawCircle(
        eyeCenter.translate(pupilOffset.dx, pupilOffset.dy),
        pupilRadius * 0.8,
        pupilPaint,
      );

      // Add small reflection dot for liveliness
      final reflectionPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        eyeCenter.translate(
          pupilOffset.dx - pupilRadius * 0.3,
          pupilOffset.dy - pupilRadius * 0.3,
        ),
        pupilRadius * 0.25,
        reflectionPaint,
      );
    }
  }

  void _drawXEyes(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03
          ..strokeCap = StrokeCap.round;

    // Left X eye
    final leftEyeX1Start = Offset(
      center.dx + expression.leftEyePositions[0].dx * radius,
      center.dy + expression.leftEyePositions[0].dy * radius,
    );
    final leftEyeX1End = Offset(
      center.dx + expression.leftEyePositions[1].dx * radius,
      center.dy + expression.leftEyePositions[1].dy * radius,
    );

    final leftEyeX2Start = Offset(
      center.dx + expression.leftEyePositions[2].dx * radius,
      center.dy + expression.leftEyePositions[2].dy * radius,
    );
    final leftEyeX2End = Offset(
      center.dx + expression.leftEyePositions[3].dx * radius,
      center.dy + expression.leftEyePositions[3].dy * radius,
    );

    canvas.drawLine(leftEyeX1Start, leftEyeX1End, paint);
    canvas.drawLine(leftEyeX2Start, leftEyeX2End, paint);

    // Right X eye
    final rightEyeX1Start = Offset(
      center.dx + expression.rightEyePositions[0].dx * radius,
      center.dy + expression.rightEyePositions[0].dy * radius,
    );
    final rightEyeX1End = Offset(
      center.dx + expression.rightEyePositions[1].dx * radius,
      center.dy + expression.rightEyePositions[1].dy * radius,
    );

    final rightEyeX2Start = Offset(
      center.dx + expression.rightEyePositions[2].dx * radius,
      center.dy + expression.rightEyePositions[2].dy * radius,
    );
    final rightEyeX2End = Offset(
      center.dx + expression.rightEyePositions[3].dx * radius,
      center.dy + expression.rightEyePositions[3].dy * radius,
    );

    canvas.drawLine(rightEyeX1Start, rightEyeX1End, paint);
    canvas.drawLine(rightEyeX2Start, rightEyeX2End, paint);
  }

  void _drawHeartEyes(Canvas canvas, Offset center, double radius) {
    final heartPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    // Left heart eye
    final leftHeartCenter = Offset(
      center.dx + expression.extraFeaturePositions[0].dx * radius,
      center.dy + expression.extraFeaturePositions[0].dy * radius,
    );

    // Right heart eye
    final rightHeartCenter = Offset(
      center.dx + expression.extraFeaturePositions[1].dx * radius,
      center.dy + expression.extraFeaturePositions[1].dy * radius,
    );

    _drawHeart(canvas, leftHeartCenter, radius * 0.15, heartPaint);
    _drawHeart(canvas, rightHeartCenter, radius * 0.15, heartPaint);
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03
          ..strokeCap = StrokeCap.round;

    // Special mouth shapes
    switch (expression.type) {
      case ExpressionType.sleepy:
        // Draw a small circular mouth for sleepy expression
        final mouthCenter = Offset(
          center.dx + expression.mouthPositions[0].dx * radius,
          center.dy + expression.mouthPositions[0].dy * radius,
        );

        // Small elliptical mouth
        final mouthRect = Rect.fromCenter(
          center: mouthCenter,
          width: radius * 0.05,
          height: radius * 0.04,
        );

        // Fill ellipse with black
        final mouthPaint =
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.fill;

        canvas.drawOval(mouthRect, mouthPaint);
        return;
      case ExpressionType.surprised:
        // Small O-shaped mouth like in the image
        final mouthCenter = Offset(
          center.dx + expression.extraFeaturePositions[0].dx * radius,
          center.dy + expression.extraFeaturePositions[0].dy * radius,
        );
        final mouthRadius = radius * 0.05; // Smaller O shape

        final mouthPath = Path();
        mouthPath.addOval(
          Rect.fromCircle(center: mouthCenter, radius: mouthRadius),
        );

        paint.style = PaintingStyle.fill;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.vampire:
        // Mouth with fangs
        _drawVampireMouth(canvas, center, radius);
        return;

      case ExpressionType.laughing:
        // Zigzag laughing mouth more like in the image
        _drawLaughingMouth(canvas, center, radius);
        return;

      case ExpressionType.happy:
        // Draw a D-shaped happy mouth like in the image
        final mouthLeft = Offset(
          center.dx - radius * 0.12,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.12,
          center.dy + radius * 0.2,
        );

        final mouthPath = Path();
        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        mouthPath.lineTo(mouthRight.dx, mouthRight.dy);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.28, // Increased depth of smile
          mouthLeft.dx,
          mouthLeft.dy,
        );

        paint.style = PaintingStyle.fill;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.cute:
        // Small curved smile for cute expression
        final mouthPath = Path();
        final mouthWidth = radius * 0.08;

        mouthPath.moveTo(center.dx - mouthWidth, center.dy + radius * 0.18);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.22,
          center.dx + mouthWidth,
          center.dy + radius * 0.18,
        );

        paint.style = PaintingStyle.stroke;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.sad:
      case ExpressionType.crying:
      case ExpressionType.worried:
        // Downturned mouth like in the image
        final mouthLeft = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.1,
          center.dy + radius * 0.2,
        );

        final mouthPath = Path();
        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy +
              radius * 0.15, // Control point higher for downturned mouth
          mouthRight.dx,
          mouthRight.dy,
        );

        paint.style = PaintingStyle.stroke;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.wink:
        // Asymmetrical slight smile for wink
        final mouthLeft = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.12,
          center.dy + radius * 0.18, // Slightly higher right corner
        );

        final mouthPath = Path();
        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.22,
          mouthRight.dx,
          mouthRight.dy,
        );

        paint.style = PaintingStyle.stroke;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.smirk:
        // One-sided smirk like in the image
        final mouthLeft = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.19,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.15,
          center.dy + radius * 0.17, // Higher end point for smirk
        );

        final mouthPath = Path();
        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        mouthPath.quadraticBezierTo(
          center.dx + radius * 0.05, // Control point shifted right
          center.dy + radius * 0.22,
          mouthRight.dx,
          mouthRight.dy,
        );

        paint.style = PaintingStyle.stroke;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.thinking:
        // Small off-center dot for thinking expression
        final mouthPath = Path();
        final dotCenter = Offset(center.dx, center.dy + radius * 0.2);

        // Draw a small dot instead of a line
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(dotCenter, radius * 0.02, paint);
        return;

      case ExpressionType.confused:
        // Squiggly confused mouth like in the image
        final mouthStart = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.19,
        );
        final mouthMiddle = Offset(center.dx, center.dy + radius * 0.21);
        final mouthEnd = Offset(
          center.dx + radius * 0.1,
          center.dy + radius * 0.18,
        );

        final mouthPath = Path();
        mouthPath.moveTo(mouthStart.dx, mouthStart.dy);
        mouthPath.quadraticBezierTo(
          center.dx - radius * 0.05,
          center.dy + radius * 0.18,
          mouthMiddle.dx,
          mouthMiddle.dy,
        );
        mouthPath.quadraticBezierTo(
          center.dx + radius * 0.05,
          center.dy + radius * 0.24,
          mouthEnd.dx,
          mouthEnd.dy,
        );

        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.catty:
        // Cat-like small 3 shape mouth as in the image
        final mouthPath = Path();
        mouthPath.moveTo(center.dx - radius * 0.05, center.dy + radius * 0.18);
        mouthPath.lineTo(center.dx, center.dy + radius * 0.21);
        mouthPath.lineTo(center.dx + radius * 0.05, center.dy + radius * 0.18);

        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.neutral:
        // Small, slightly curved line for neutral expression
        final mouthPath = Path();
        final mouthLeft = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.1,
          center.dy + radius * 0.2,
        );

        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        // Very slight curve for a more natural look
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.205,
          mouthRight.dx,
          mouthRight.dy,
        );

        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.angry:
        // Frowning mouth for angry expression
        final mouthPath = Path();
        final mouthLeft = Offset(
          center.dx - radius * 0.1,
          center.dy + radius * 0.22, // Lower corners
        );
        final mouthRight = Offset(
          center.dx + radius * 0.1,
          center.dy + radius * 0.22,
        );

        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        // Control point higher for an inverted curve (frown)
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.18,
          mouthRight.dx,
          mouthRight.dy,
        );

        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.blushing:
        // Small, subtle smile for blushing
        final mouthPath = Path();
        final mouthLeft = Offset(
          center.dx - radius * 0.08,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.08,
          center.dy + radius * 0.2,
        );

        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.22,
          mouthRight.dx,
          mouthRight.dy,
        );

        paint.style = PaintingStyle.stroke;
        canvas.drawPath(mouthPath, paint);
        return;

      case ExpressionType.sleepy:
        // Slight curved line for sleepy expression
        final mouthPath = Path();
        final mouthLeft = Offset(
          center.dx - radius * 0.08,
          center.dy + radius * 0.2,
        );
        final mouthRight = Offset(
          center.dx + radius * 0.08,
          center.dy + radius * 0.2,
        );

        mouthPath.moveTo(mouthLeft.dx, mouthLeft.dy);
        // Very slight curve
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + radius * 0.21,
          mouthRight.dx,
          mouthRight.dy,
        );

        canvas.drawPath(mouthPath, paint);
        return;

      default:
        // Default curved mouth for other expressions
        final points =
            expression.mouthPositions.map((offset) {
              return Offset(
                center.dx + offset.dx * radius,
                center.dy + offset.dy * radius,
              );
            }).toList();

        if (points.length >= 3) {
          final path = Path();
          path.moveTo(points[0].dx, points[0].dy);

          if (points.length == 3) {
            // Simple curved mouth with one control point
            path.quadraticBezierTo(
              points[1].dx,
              points[1].dy,
              points[2].dx,
              points[2].dy,
            );
          } else if (points.length > 3) {
            // More complex mouth shape with multiple points
            for (int i = 1; i < points.length - 1; i++) {
              // Use quadratic bezier curves between points for smoothness
              path.quadraticBezierTo(
                points[i].dx,
                points[i].dy,
                (points[i].dx + points[i + 1].dx) / 2,
                (points[i].dy + points[i + 1].dy) / 2,
              );
            }
            // Connect to the last point
            path.lineTo(points.last.dx, points.last.dy);
          }

          paint.style = PaintingStyle.stroke;
          canvas.drawPath(path, paint);
        }
    }
  }

  // Add this method to the FacePainter class to handle drawing Z characters
  void _drawSleepyExpression(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.02
          ..strokeCap = StrokeCap.round;

    // Draw Z characters
    if (expression.extraFeaturePositions.length >= 3) {
      // Main Z (largest)
      _drawZCharacter(
        canvas,
        Offset(
          center.dx + expression.extraFeaturePositions[0].dx * radius,
          center.dy + expression.extraFeaturePositions[0].dy * radius,
        ),
        radius * 0.08,
        paint,
      );

      // Medium Z
      _drawZCharacter(
        canvas,
        Offset(
          center.dx + expression.extraFeaturePositions[1].dx * radius,
          center.dy + expression.extraFeaturePositions[1].dy * radius,
        ),
        radius * 0.06,
        paint,
      );

      // Small Z
      _drawZCharacter(
        canvas,
        Offset(
          center.dx + expression.extraFeaturePositions[2].dx * radius,
          center.dy + expression.extraFeaturePositions[2].dy * radius,
        ),
        radius * 0.04,
        paint,
      );
    }
  }

  // Helper method to draw Z characters
  void _drawZCharacter(
    Canvas canvas,
    Offset position,
    double size,
    Paint paint,
  ) {
    final topLeft = position.translate(-size / 2, -size / 2);
    final topRight = position.translate(size / 2, -size / 2);
    final bottomLeft = position.translate(-size / 2, size / 2);
    final bottomRight = position.translate(size / 2, size / 2);

    final zPath = Path();
    zPath.moveTo(topLeft.dx, topLeft.dy);
    zPath.lineTo(topRight.dx, topRight.dy);
    zPath.lineTo(bottomLeft.dx, bottomLeft.dy);
    zPath.lineTo(bottomRight.dx, bottomRight.dy);

    canvas.drawPath(zPath, paint);
  }

  void _drawVampireMouth(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03
          ..strokeCap = StrokeCap.round;

    final fangPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final fangStrokePaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.01;

    final points =
        expression.mouthPositions.map((offset) {
          return Offset(
            center.dx + offset.dx * radius,
            center.dy + offset.dy * radius,
          );
        }).toList();

    // Draw smile curved mouth (like in the image)
    final mouthPath = Path();
    mouthPath.moveTo(points[0].dx, points[0].dy);
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.25, // Control point for curve
      points[4].dx,
      points[4].dy,
    );

    canvas.drawPath(mouthPath, paint);

    // Draw left fang - smaller and more like in the image
    final leftFang = Path();
    leftFang.moveTo(points[1].dx, points[1].dy);
    leftFang.lineTo(points[1].dx - radius * 0.02, points[1].dy + radius * 0.05);
    leftFang.lineTo(points[1].dx + radius * 0.01, points[1].dy);
    leftFang.close();

    canvas.drawPath(leftFang, fangPaint);
    canvas.drawPath(leftFang, fangStrokePaint);

    // Draw right fang - smaller and more like in the image
    final rightFang = Path();
    rightFang.moveTo(points[3].dx, points[3].dy);
    rightFang.lineTo(
      points[3].dx + radius * 0.02,
      points[3].dy + radius * 0.05,
    );
    rightFang.lineTo(points[3].dx - radius * 0.01, points[3].dy);
    rightFang.close();

    canvas.drawPath(rightFang, fangPaint);
    canvas.drawPath(rightFang, fangStrokePaint);
  }

  void _drawLaughingMouth(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    final points =
        expression.mouthPositions.map((offset) {
          return Offset(
            center.dx + offset.dx * radius,
            center.dy + offset.dy * radius,
          );
        }).toList();

    // Draw a zigzag laughing mouth like in the image
    final mouthPath = Path();
    mouthPath.moveTo(points[0].dx, points[0].dy);

    // First curve down
    mouthPath.quadraticBezierTo(
      points[1].dx,
      points[1].dy,
      points[2].dx,
      points[2].dy,
    );

    // Second curve up
    mouthPath.quadraticBezierTo(
      points[3].dx,
      points[3].dy,
      points[4].dx,
      points[4].dy,
    );

    // Close the shape to fill it
    mouthPath.lineTo(points[4].dx, points[4].dy + radius * 0.05);
    mouthPath.lineTo(points[0].dx, points[0].dy + radius * 0.05);
    mouthPath.close();

    canvas.drawPath(mouthPath, fillPaint);

    // Draw the zigzag line at the top of the mouth
    final topLinePath = Path();
    topLinePath.moveTo(points[0].dx, points[0].dy);

    // First curve down
    topLinePath.quadraticBezierTo(
      points[1].dx,
      points[1].dy,
      points[2].dx,
      points[2].dy,
    );

    // Second curve up
    topLinePath.quadraticBezierTo(
      points[3].dx,
      points[3].dy,
      points[4].dx,
      points[4].dy,
    );

    canvas.drawPath(topLinePath, paint);
  }

  void _drawSpecialFeatures(Canvas canvas, Offset center, double radius) {
    // Draw blush if needed
    if (expression.hasBlush) {
      final blushPaint =
          Paint()
            ..color = Colors.pink.withOpacity(0.3)
            ..style = PaintingStyle.fill;

      for (final offset in expression.blushPositions) {
        final blushCenter = Offset(
          center.dx + offset.dx * radius,
          center.dy + offset.dy * radius,
        );

        canvas.drawCircle(blushCenter, radius * 0.1, blushPaint);
      }
    }

    // Draw tears if needed
    if (expression.tearsDrop) {
      final tearPaint =
          Paint()
            ..color = Colors.lightBlue.withOpacity(0.7)
            ..style = PaintingStyle.fill;

      for (final offset in expression.extraFeaturePositions) {
        final tearTopCenter = Offset(
          center.dx + offset.dx * radius,
          center.dy + offset.dy * radius,
        );

        // Draw tear drop shape
        final tearPath = Path();
        tearPath.moveTo(tearTopCenter.dx, tearTopCenter.dy);
        tearPath.quadraticBezierTo(
          tearTopCenter.dx - radius * 0.03,
          tearTopCenter.dy + radius * 0.05,
          tearTopCenter.dx,
          tearTopCenter.dy + radius * 0.1,
        );
        tearPath.quadraticBezierTo(
          tearTopCenter.dx + radius * 0.03,
          tearTopCenter.dy + radius * 0.05,
          tearTopCenter.dx,
          tearTopCenter.dy + radius * 0.1,
        );
        tearPath.close();

        canvas.drawPath(tearPath, tearPaint);
      }
    }

    // Draw glasses if needed
    if (expression.hasGlasses) {
      final glassesPaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.02;

      // Left lens
      final leftLensCenter = Offset(center.dx - radius * 0.15, center.dy);

      // Right lens
      final rightLensCenter = Offset(center.dx + radius * 0.15, center.dy);

      // Draw lenses
      canvas.drawCircle(leftLensCenter, radius * 0.12, glassesPaint);
      canvas.drawCircle(rightLensCenter, radius * 0.12, glassesPaint);

      // Draw bridge
      canvas.drawLine(
        Offset(leftLensCenter.dx + radius * 0.12, leftLensCenter.dy),
        Offset(rightLensCenter.dx - radius * 0.12, rightLensCenter.dy),
        glassesPaint,
      );

      // Draw temple arms
      canvas.drawLine(
        Offset(leftLensCenter.dx - radius * 0.12, leftLensCenter.dy),
        Offset(
          leftLensCenter.dx - radius * 0.2,
          leftLensCenter.dy - radius * 0.05,
        ),
        glassesPaint,
      );

      canvas.drawLine(
        Offset(rightLensCenter.dx + radius * 0.12, rightLensCenter.dy),
        Offset(
          rightLensCenter.dx + radius * 0.2,
          rightLensCenter.dy - radius * 0.05,
        ),
        glassesPaint,
      );
    }

    // Draw music notes if needed
    if (expression.hasMusic) {
      final musicPaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.fill
            ..strokeWidth = radius * 0.02;

      final notePosition = Offset(
        center.dx + expression.extraFeaturePositions[0].dx * radius,
        center.dy + expression.extraFeaturePositions[0].dy * radius,
      );

      // Draw music note
      final noteHeadRadius = radius * 0.04;

      // Note head
      canvas.drawCircle(notePosition, noteHeadRadius, musicPaint);

      // Note stem
      canvas.drawLine(
        Offset(notePosition.dx + noteHeadRadius, notePosition.dy),
        Offset(
          notePosition.dx + noteHeadRadius,
          notePosition.dy - radius * 0.1,
        ),
        musicPaint..strokeWidth = radius * 0.02,
      );

      // Note flag
      final flagPath = Path();
      flagPath.moveTo(
        notePosition.dx + noteHeadRadius,
        notePosition.dy - radius * 0.1,
      );
      flagPath.quadraticBezierTo(
        notePosition.dx + noteHeadRadius + radius * 0.05,
        notePosition.dy - radius * 0.09,
        notePosition.dx + noteHeadRadius + radius * 0.05,
        notePosition.dy - radius * 0.06,
      );
      flagPath.lineTo(
        notePosition.dx + noteHeadRadius,
        notePosition.dy - radius * 0.07,
      );

      canvas.drawPath(flagPath, musicPaint);

      // Second note
      final note2Position = Offset(
        notePosition.dx - radius * 0.1,
        notePosition.dy + radius * 0.05,
      );

      // Note head
      canvas.drawCircle(note2Position, noteHeadRadius, musicPaint);

      // Note stem
      canvas.drawLine(
        Offset(note2Position.dx + noteHeadRadius, note2Position.dy),
        Offset(
          note2Position.dx + noteHeadRadius,
          note2Position.dy - radius * 0.1,
        ),
        musicPaint..strokeWidth = radius * 0.02,
      );
    }

    // Draw cat features if needed
    if (expression.type == ExpressionType.catty) {
      final catPaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.02
            ..strokeCap = StrokeCap.round;

      // Cat ears
      final leftEarPosition = Offset(
        center.dx + expression.extraFeaturePositions[0].dx * radius,
        center.dy + expression.extraFeaturePositions[0].dy * radius,
      );

      final rightEarPosition = Offset(
        center.dx + expression.extraFeaturePositions[1].dx * radius,
        center.dy + expression.extraFeaturePositions[1].dy * radius,
      );

      // Left ear
      final leftEarPath = Path();
      leftEarPath.moveTo(center.dx - radius * 0.3, center.dy - radius * 0.1);
      leftEarPath.lineTo(leftEarPosition.dx, leftEarPosition.dy);
      leftEarPath.lineTo(center.dx - radius * 0.1, center.dy - radius * 0.1);

      canvas.drawPath(leftEarPath, catPaint);

      // Right ear
      final rightEarPath = Path();
      rightEarPath.moveTo(center.dx + radius * 0.3, center.dy - radius * 0.1);
      rightEarPath.lineTo(rightEarPosition.dx, rightEarPosition.dy);
      rightEarPath.lineTo(center.dx + radius * 0.1, center.dy - radius * 0.1);

      canvas.drawPath(rightEarPath, catPaint);

      // Whiskers
      final whiskerCenter = Offset(
        center.dx + expression.extraFeaturePositions[2].dx * radius,
        center.dy + expression.extraFeaturePositions[2].dy * radius,
      );

      // Left whiskers
      canvas.drawLine(
        Offset(
          whiskerCenter.dx - radius * 0.05,
          whiskerCenter.dy - radius * 0.05,
        ),
        Offset(
          whiskerCenter.dx - radius * 0.25,
          whiskerCenter.dy - radius * 0.1,
        ),
        catPaint,
      );

      canvas.drawLine(
        Offset(whiskerCenter.dx - radius * 0.05, whiskerCenter.dy),
        Offset(whiskerCenter.dx - radius * 0.25, whiskerCenter.dy),
        catPaint,
      );

      canvas.drawLine(
        Offset(
          whiskerCenter.dx - radius * 0.05,
          whiskerCenter.dy + radius * 0.05,
        ),
        Offset(
          whiskerCenter.dx - radius * 0.25,
          whiskerCenter.dy + radius * 0.1,
        ),
        catPaint,
      );

      // Right whiskers
      canvas.drawLine(
        Offset(
          whiskerCenter.dx + radius * 0.05,
          whiskerCenter.dy - radius * 0.05,
        ),
        Offset(
          whiskerCenter.dx + radius * 0.25,
          whiskerCenter.dy - radius * 0.1,
        ),
        catPaint,
      );

      canvas.drawLine(
        Offset(whiskerCenter.dx + radius * 0.05, whiskerCenter.dy),
        Offset(whiskerCenter.dx + radius * 0.25, whiskerCenter.dy),
        catPaint,
      );

      canvas.drawLine(
        Offset(
          whiskerCenter.dx + radius * 0.05,
          whiskerCenter.dy + radius * 0.05,
        ),
        Offset(
          whiskerCenter.dx + radius * 0.25,
          whiskerCenter.dy + radius * 0.1,
        ),
        catPaint,
      );
    }

    // Draw thought bubble for thinking expression
    if (expression.type == ExpressionType.thinking) {
      final bubblePaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.02;

      final thoughtPosition = Offset(
        center.dx + expression.extraFeaturePositions[0].dx * radius,
        center.dy + expression.extraFeaturePositions[0].dy * radius,
      );

      // Main thought bubble
      canvas.drawCircle(thoughtPosition, radius * 0.1, bubblePaint);

      // Small bubbles
      canvas.drawCircle(
        Offset(
          thoughtPosition.dx - radius * 0.15,
          thoughtPosition.dy + radius * 0.1,
        ),
        radius * 0.05,
        bubblePaint,
      );

      canvas.drawCircle(
        Offset(
          thoughtPosition.dx - radius * 0.22,
          thoughtPosition.dy + radius * 0.18,
        ),
        radius * 0.03,
        bubblePaint,
      );

      canvas.drawCircle(
        Offset(
          thoughtPosition.dx - radius * 0.27,
          thoughtPosition.dy + radius * 0.23,
        ),
        radius * 0.015,
        bubblePaint,
      );
    }

    // Draw question mark for confused expression
    if (expression.type == ExpressionType.confused) {
      final questionPaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.02
            ..strokeCap = StrokeCap.round;

      final questionPosition = Offset(
        center.dx + expression.extraFeaturePositions[0].dx * radius,
        center.dy + expression.extraFeaturePositions[0].dy * radius,
      );

      // Question mark curve
      final questionPath = Path();
      questionPath.moveTo(
        questionPosition.dx - radius * 0.03,
        questionPosition.dy - radius * 0.08,
      );
      questionPath.quadraticBezierTo(
        questionPosition.dx,
        questionPosition.dy - radius * 0.12,
        questionPosition.dx + radius * 0.03,
        questionPosition.dy - radius * 0.08,
      );
      questionPath.quadraticBezierTo(
        questionPosition.dx + radius * 0.05,
        questionPosition.dy - radius * 0.04,
        questionPosition.dx,
        questionPosition.dy,
      );

      canvas.drawPath(questionPath, questionPaint);

      // Question mark dot
      canvas.drawCircle(
        Offset(questionPosition.dx, questionPosition.dy + radius * 0.05),
        radius * 0.01,
        questionPaint..style = PaintingStyle.fill,
      );
    }
    if (expression.type == ExpressionType.sleepy) {
      _drawSleepyExpression(canvas, center, radius);
    }

    // Draw floating hearts for love expression
    if (expression.hasHearts) {
      final heartPaint =
          Paint()
            ..color = Colors.red.withOpacity(0.7)
            ..style = PaintingStyle.fill;

      // Draw a few floating hearts
      _drawHeart(
        canvas,
        Offset(center.dx - radius * 0.4, center.dy - radius * 0.3),
        radius * 0.08,
        heartPaint,
      );

      _drawHeart(
        canvas,
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.2),
        radius * 0.06,
        heartPaint,
      );

      _drawHeart(
        canvas,
        Offset(center.dx - radius * 0.2, center.dy - radius * 0.4),
        radius * 0.05,
        heartPaint,
      );
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    // More stylized heart shape like in the image
    path.moveTo(center.dx, center.dy + size * 0.3);

    // Left curve
    path.cubicTo(
      center.dx - size * 0.8,
      center.dy - size * 0.2,
      center.dx - size * 0.5,
      center.dy - size * 1.2,
      center.dx,
      center.dy - size * 0.5,
    );

    // Right curve
    path.cubicTo(
      center.dx + size * 0.5,
      center.dy - size * 1.2,
      center.dx + size * 0.8,
      center.dy - size * 0.2,
      center.dx,
      center.dy + size * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
