// lib/widgets/painters/face_painters.dart
import 'package:flutter/material.dart';

class EyebrowPainter extends CustomPainter {
  final bool isLeft;
  final Offset offset;
  final Color color;
  final double thickness;

  EyebrowPainter({
    required this.isLeft,
    required this.offset,
    this.color = Colors.white,
    this.thickness = 12.0,
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

    // Apply the offset to the eyebrow position
    final verticalOffset = offset.dy;
    final horizontalOffset = offset.dx;

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

  @override
  bool shouldRepaint(covariant EyebrowPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.color != color ||
        oldDelegate.thickness != thickness;
  }
}

class MouthPainter extends CustomPainter {
  final double curvature;
  final Color color;

  MouthPainter({required this.curvature, this.color = Colors.white});

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

    // Start point (left of mouth)
    path.moveTo(wWidth * 0.40, wHeight * 0.10);

    // Adjust control points based on curvature
    // Positive curvature = happy smile, negative = sad frown
    final double controlY = wHeight * 0.1 + (curvature * wHeight * 0.4);

    if (curvature == 0) {
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
    } else if (curvature > 0) {
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
  }

  @override
  bool shouldRepaint(covariant MouthPainter oldDelegate) {
    return oldDelegate.curvature != curvature || oldDelegate.color != color;
  }
}

class BlushPainter extends CustomPainter {
  final Color color;
  final double size;

  BlushPainter({this.color = Colors.pink, this.size = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final leftCenter = Offset(size.width * 0.3, size.height * 0.5);
    final rightCenter = Offset(size.width * 0.7, size.height * 0.5);
    final radius = size.width * 0.12 * this.size;

    canvas.drawCircle(leftCenter, radius, paint);
    canvas.drawCircle(rightCenter, radius, paint);
  }

  @override
  bool shouldRepaint(covariant BlushPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.size != size;
  }
}
