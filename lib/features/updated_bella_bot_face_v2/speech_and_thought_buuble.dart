// lib/widgets/effects/speech_bubble.dart
import 'package:flutter/material.dart';

enum BubbleType { speech, thought }

class BubbleWidget extends StatelessWidget {
  final String text;
  final BubbleType type;
  final Offset? position;
  final Color backgroundColor;
  final Color textColor;
  final List<String> emojis;
  final double scale;

  const BubbleWidget({
    Key? key,
    required this.text,
    this.type = BubbleType.speech,
    this.position,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.emojis = const [],
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
      left: position?.dx,
      top: position?.dy,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.bottomCenter,
        child:
            type == BubbleType.speech
                ? _buildSpeechBubble()
                : _buildThoughtBubble(),
      ),
    );
  }

  Widget _buildSpeechBubble() {
    return CustomPaint(
      painter: SpeechBubblePainter(backgroundColor: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildThoughtBubble() {
    return CustomPaint(
      painter: ThoughtBubblePainter(backgroundColor: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (emojis.isNotEmpty) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                emojis
                    .take(3) // Limit to 3 emojis
                    .map(
                      (emoji) =>
                          Text(emoji, style: const TextStyle(fontSize: 24)),
                    )
                    .toList(),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color backgroundColor;

  SpeechBubblePainter({this.backgroundColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();

    // Bubble body with rounded corners
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 15),
      const Radius.circular(16),
    );

    // Draw shadow first
    final shadowPath = Path()..addRRect(rrect);

    // Add the speech pointer
    shadowPath.moveTo(size.width * 0.5, size.height - 15);
    shadowPath.lineTo(size.width * 0.3, size.height);
    shadowPath.lineTo(size.width * 0.5, size.height - 5);

    canvas.drawPath(shadowPath, shadowPaint);

    // Draw bubble body
    path.addRRect(rrect);

    // Draw the speech pointer
    path.moveTo(size.width * 0.5, size.height - 15);
    path.lineTo(size.width * 0.3, size.height);
    path.lineTo(size.width * 0.5, size.height - 5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ThoughtBubblePainter extends CustomPainter {
  final Color backgroundColor;

  ThoughtBubblePainter({this.backgroundColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Main bubble
    final mainBubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 20),
      const Radius.circular(20),
    );

    // Shadow for main bubble
    canvas.drawRRect(mainBubble, shadowPaint);
    canvas.drawRRect(mainBubble, paint);

    // Thought bubbles in decreasing size
    double bubbleX = size.width * 0.5;
    double bubbleY = size.height - 15;
    double bubbleSize = 12;

    // Draw shadow for each bubble
    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, shadowPaint);
    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, paint);

    bubbleX -= 10;
    bubbleY += 10;
    bubbleSize = 8;

    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, shadowPaint);
    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, paint);

    bubbleX -= 7;
    bubbleY += 7;
    bubbleSize = 5;

    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, shadowPaint);
    canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
