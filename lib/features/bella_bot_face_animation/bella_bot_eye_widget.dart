// lib/widgets/bella_bot_eye.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart';

class BellaBotEye extends ConsumerWidget {
  final bool isLeft;
  final double openness;
  final double screenWidth;
  final double screenHeight;

  const BellaBotEye({
    Key? key,
    required this.isLeft,
    required this.openness,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pupilOffset = ref.watch(eyePupilPositionProvider);
    final isBlinking = ref.watch(blinkingProvider);
    final expression = ref.watch(bellaBotExpressionProvider);

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

    // Eye height transitions based on openness factor
    double currentHeight =
        eyeDiameter * (effectiveOpenness > 0.1 ? effectiveOpenness : 0.1);

    // For very closed eyes, use a rounded rectangle shape
    final useCapsuleShape = effectiveOpenness < 0.3;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        useCapsuleShape ? 15 : eyeDiameter / 2,
      ),
      child: Container(
        width: eyeDiameter,
        height: currentHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            useCapsuleShape ? 15 : eyeDiameter / 2,
          ),
        ),
        child: Transform.translate(
          offset: pupilOffset,
          child: Center(
            child: ClipOval(
              child: Container(
                width: eyeDiameter / 1.5, // Fixed width for the pupil
                height: eyeDiameter / 1.5 * effectiveOpenness,
                color: Colors.black,
                child:
                    effectiveOpenness > 0.5
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
        ),
      ),
    );
  }
}
