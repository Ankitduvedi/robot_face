// lib/widgets/effects/particle_system.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';

class ParticleSystem extends StatefulWidget {
  final List<ParticleEffect> effects;
  final Size size;
  final bool isActive;

  const ParticleSystem({
    Key? key,
    required this.effects,
    required this.size,
    this.isActive = true,
  }) : super(key: key);

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
    _generateParticles();
  }

  @override
  void didUpdateWidget(ParticleSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.effects != oldWidget.effects) {
      _particles.clear();
      _generateParticles();
    }

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.addListener(() {
      for (var particle in _particles) {
        // Update particle position
        particle.update(_animationController.value);
      }
      setState(() {}); // Redraw
    });

    if (widget.isActive) {
      _animationController.repeat();
    }
  }

  void _generateParticles() {
    for (var effect in widget.effects) {
      for (int i = 0; i < effect.count; i++) {
        _particles.add(
          Particle.fromEffect(
            effect: effect,
            size: widget.size,
            random: _random,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: ParticlePainter(particles: _particles),
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

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

class Particle {
  final ParticleType type;
  final Color color;
  final double size;
  final double speed;

  Offset position;
  Offset velocity;
  double opacity;
  double rotation;

  final Random random;

  Particle({
    required this.type,
    required this.color,
    required this.size,
    required this.speed,
    required this.position,
    required this.velocity,
    required this.opacity,
    required this.rotation,
    required this.random,
  });

  factory Particle.fromEffect({
    required ParticleEffect effect,
    required Size size,
    required Random random,
  }) {
    // Random starting position
    final position = Offset(
      random.nextDouble() * size.width,
      random.nextDouble() * size.height,
    );

    // Random velocity
    final speed = effect.speed * (0.5 + random.nextDouble() * 0.5);
    final angle = random.nextDouble() * 2 * pi;
    final velocity = Offset(cos(angle) * speed, sin(angle) * speed);

    // Initial opacity and rotation
    final opacity = 0.5 + random.nextDouble() * 0.5;
    final rotation = random.nextDouble() * 2 * pi;

    return Particle(
      type: effect.type,
      color: effect.color,
      size: effect.size * (0.5 + random.nextDouble() * 0.5),
      speed: speed,
      position: position,
      velocity: velocity,
      opacity: opacity,
      rotation: rotation,
      random: random,
    );
  }

  void update(double animationValue) {
    // Move the particle
    position += velocity;

    // Add some randomness to movement
    position += Offset(
      (random.nextDouble() * 2 - 1) * 0.5,
      (random.nextDouble() * 2 - 1) * 0.5,
    );

    // Update rotation
    rotation += 0.01 * speed;

    // Update opacity for fade in/out
    if (animationValue < 0.3) {
      opacity = animationValue / 0.3; // Fade in
    } else if (animationValue > 0.7) {
      opacity = (1 - animationValue) / 0.3; // Fade out
    }
  }

  void draw(Canvas canvas, Size size) {
    // Wrap around screen edges
    if (position.dx < 0) position = Offset(size.width, position.dy);
    if (position.dx > size.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, size.height);
    if (position.dy > size.height) position = Offset(position.dx, 0);

    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    // Draw different particle shapes based on type
    switch (type) {
      case ParticleType.bubble:
        _drawBubble(canvas, paint);
        break;
      case ParticleType.sparkle:
        _drawSparkle(canvas, paint);
        break;
      case ParticleType.raindrop:
        _drawRaindrop(canvas, paint);
        break;
      case ParticleType.heart:
        _drawHeart(canvas, paint);
        break;
      case ParticleType.star:
        _drawStar(canvas, paint);
        break;
      case ParticleType.lightning:
        _drawLightning(canvas, paint);
        break;
      case ParticleType.snowflake:
        _drawSnowflake(canvas, paint);
        break;
      case ParticleType.confetti:
        _drawConfetti(canvas, paint);
        break;
    }

    canvas.restore();
  }

  void _drawBubble(Canvas canvas, Paint paint) {
    // Main bubble
    canvas.drawCircle(Offset.zero, size, paint);

    // Highlight
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(opacity * 0.7)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(-size * 0.3, -size * 0.3),
      size * 0.2,
      highlightPaint,
    );
  }

  void _drawSparkle(Canvas canvas, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final outerPoint = Offset(
        cos(angle) * outerRadius,
        sin(angle) * outerRadius,
      );
      final innerPoint = Offset(
        cos(angle + pi / 8) * innerRadius,
        sin(angle + pi / 8) * innerRadius,
      );

      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }

      path.lineTo(innerPoint.dx, innerPoint.dy);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRaindrop(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(0, -size);

    // Draw teardrop shape
    path.quadraticBezierTo(size, 0, 0, size);
    path.quadraticBezierTo(-size, 0, 0, -size);

    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(0, size * 0.3);

    // Top left curve
    path.cubicTo(
      -size * 0.6,
      -size * 0.4,
      -size * 1.2,
      size * 0.1,
      0,
      size * 1.0,
    );

    // Top right curve
    path.cubicTo(
      size * 1.2,
      size * 0.1,
      size * 0.6,
      -size * 0.4,
      0,
      size * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < 5; i++) {
      final outerAngle = i * 2 * pi / 5 - pi / 2;
      final innerAngle = outerAngle + pi / 5;

      final outerPoint = Offset(
        cos(outerAngle) * outerRadius,
        sin(outerAngle) * outerRadius,
      );
      final innerPoint = Offset(
        cos(innerAngle) * innerRadius,
        sin(innerAngle) * innerRadius,
      );

      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }

      path.lineTo(innerPoint.dx, innerPoint.dy);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLightning(Canvas canvas, Paint paint) {
    final path = Path();

    // Lightning bolt shape
    path.moveTo(0, -size);
    path.lineTo(size * 0.2, -size * 0.2);
    path.lineTo(-size * 0.2, -size * 0.2);
    path.lineTo(0, size);
    path.lineTo(-size * 0.2, size * 0.2);
    path.lineTo(size * 0.2, size * 0.2);
    path.lineTo(0, -size);

    canvas.drawPath(path, paint);
  }

  void _drawSnowflake(Canvas canvas, Paint paint) {
    for (int i = 0; i < 3; i++) {
      final angle = i * pi / 3;

      // Draw lines
      canvas.save();
      canvas.rotate(angle);
      canvas.drawLine(
        Offset(-size, 0),
        Offset(size, 0),
        paint..strokeWidth = size * 0.15,
      );

      // Draw small perpendicular lines
      canvas.drawLine(
        Offset(-size * 0.6, -size * 0.2),
        Offset(-size * 0.6, size * 0.2),
        paint..strokeWidth = size * 0.1,
      );

      canvas.drawLine(
        Offset(size * 0.6, -size * 0.2),
        Offset(size * 0.6, size * 0.2),
        paint..strokeWidth = size * 0.1,
      );

      canvas.restore();
    }
  }

  void _drawConfetti(Canvas canvas, Paint paint) {
    // Draw rectangular confetti
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size * 0.8,
        height: size * 1.5,
      ),
      paint,
    );

    // Add a highlight
    final highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(opacity * 0.5)
          ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(-size * 0.2, -size * 0.4),
        width: size * 0.3,
        height: size * 0.6,
      ),
      highlightPaint,
    );
  }
}
