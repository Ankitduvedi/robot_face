// lib/widgets/effects/audio_visualizer.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';

class AudioVisualizer extends StatefulWidget {
  final AudioVisualData audioData;
  final Color color;
  final double height;
  final double width;
  final bool isListening;
  final bool isProcessing;

  const AudioVisualizer({
    Key? key,
    required this.audioData,
    this.color = Colors.blue,
    this.height = 50,
    this.width = 150,
    this.isListening = false,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  _AudioVisualizerState createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Random _random = Random();
  late List<double> _simulatedAmplitudes;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _simulatedAmplitudes = _generateRandomAmplitudes();
  }

  @override
  void didUpdateWidget(AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update active state
    if (widget.isListening != oldWidget.isListening ||
        widget.isProcessing != oldWidget.isProcessing) {
      if (widget.isListening || widget.isProcessing) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }

    // If we have actual audio data, use it
    if (widget.audioData.isActive && widget.audioData.amplitudes.isNotEmpty) {
      _simulatedAmplitudes = List.from(widget.audioData.amplitudes);
    }
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.addListener(() {
      // Generate new amplitudes for animation
      if (_animationController.status == AnimationStatus.completed) {
        setState(() {
          _simulatedAmplitudes = _generateRandomAmplitudes();
        });
        _animationController.forward(from: 0.0);
      }
    });

    if (widget.isListening || widget.isProcessing) {
      _animationController.repeat();
    }
  }

  List<double> _generateRandomAmplitudes() {
    // Generate different patterns based on listening vs processing
    if (widget.isProcessing) {
      return _generateProcessingPattern();
    } else if (widget.isListening) {
      return _generateListeningPattern();
    } else {
      return List.generate(15, (_) => 0.1); // Idle state
    }
  }

  List<double> _generateListeningPattern() {
    // Create a wave-like pattern for listening
    final count = 15;
    return List.generate(count, (i) {
      // Base amplitude
      double amp = 0.2 + _random.nextDouble() * 0.6;

      // Apply wave pattern
      double wave = sin(i / count * pi * 2) * 0.4 + 0.6;
      return amp * wave;
    });
  }

  List<double> _generateProcessingPattern() {
    // Create a more structured pattern for processing
    final count = 15;
    return List.generate(count, (i) {
      // Create a rising pattern in the middle
      double position = i / count;
      if (position < 0.4 || position > 0.6) {
        return 0.2 + _random.nextDouble() * 0.3;
      } else {
        // Higher bars in the middle
        return 0.6 + _random.nextDouble() * 0.4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.color.withOpacity(0.1),
      ),
      child: CustomPaint(
        painter: AudioWavePainter(
          amplitudes: _simulatedAmplitudes,
          color: widget.color,
          animationValue: _animationController.value,
          isProcessing: widget.isProcessing,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    // TODO: implement createTicker
    throw UnimplementedError();
  }
}

class AudioWavePainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;
  final double animationValue;
  final bool isProcessing;

  AudioWavePainter({
    required this.amplitudes,
    required this.color,
    required this.animationValue,
    this.isProcessing = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / amplitudes.length;
    final maxBarHeight = size.height * 0.8;

    // Get interpolated amplitudes
    final currentAmplitudes = _interpolateAmplitudes(amplitudes);

    for (int i = 0; i < currentAmplitudes.length; i++) {
      final amplitude = currentAmplitudes[i];
      final barHeight = amplitude * maxBarHeight;

      final rect = Rect.fromLTWH(
        i * barWidth,
        (size.height - barHeight) / 2, // Center vertically
        barWidth * 0.7, // Leave some space between bars
        barHeight,
      );

      // Different visual styles for processing vs listening
      if (isProcessing) {
        _drawProcessingBar(canvas, rect);
      } else {
        _drawListeningBar(canvas, rect);
      }
    }
  }

  void _drawListeningBar(Canvas canvas, Rect rect) {
    // Gradient for listening bars
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [color.withOpacity(0.6), color.withOpacity(0.9)],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round;

    // Draw with rounded corners
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    canvas.drawRRect(rrect, paint);
  }

  void _drawProcessingBar(Canvas canvas, Rect rect) {
    // More tech-looking style for processing
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Inner fill
    final fillPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    // Draw as rectangles with digital look
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, paint);

    // Add a scanning line effect
    final scanLinePos = rect.left + rect.width * animationValue;
    if (scanLinePos >= rect.left && scanLinePos <= rect.right) {
      final scanPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.7)
            ..strokeWidth = 1.0;

      canvas.drawLine(
        Offset(scanLinePos, rect.top),
        Offset(scanLinePos, rect.bottom),
        scanPaint,
      );
    }
  }

  List<double> _interpolateAmplitudes(List<double> source) {
    // For smooth animation, interpolate between current and random amplitudes
    return source.map((amp) {
      // Add slight animation based on animationValue for smoother transitions
      final variation = sin(animationValue * pi * 2) * 0.2;
      return (amp + variation).clamp(0.1, 1.0);
    }).toList();
  }

  @override
  bool shouldRepaint(covariant AudioWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
