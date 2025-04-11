// widgets/robot_face.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/face_animation/face_painter.dart';
import 'package:robot_display_v2/features/face_animation/provider.dart';

class RobotFace extends ConsumerWidget {
  final AnimationController blinkController;

  const RobotFace({Key? key, required this.blinkController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expression = ref.watch(faceExpressionProvider);
    final isBlinking = ref.watch(blinkingProvider);
    final size = MediaQuery.of(context).size;
    final faceSize = min(size.width * 0.8, size.height * 0.6);

    return Container(
      width: faceSize,
      height: faceSize,
      decoration: BoxDecoration(
        color: expression.faceColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: CustomPaint(
        painter: FacePainter(
          expression: expression,
          blinkController: blinkController,
          isBlinking: isBlinking,
        ),
      ),
    );
  }
}
