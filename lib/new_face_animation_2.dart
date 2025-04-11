import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main application entry point

// Providers
final faceExpressionProvider =
    StateNotifierProvider<FaceExpressionNotifier, FaceExpression>((ref) {
      return FaceExpressionNotifier();
    });

final blinkingProvider = StateProvider<bool>((ref) => false);

// Face Expression States
enum ExpressionType {
  neutral,
  happy,
  surprised,
  thinking,
  confused,
  wink,
  love,
  sleepy,
}

class FaceExpression {
  final ExpressionType type;
  final double mouthCurvature;
  final double eyeSize;
  final double eyebrowAngle;
  final Color faceColor;
  final bool specialAnimation;

  FaceExpression({
    required this.type,
    required this.mouthCurvature,
    required this.eyeSize,
    required this.eyebrowAngle,
    required this.faceColor,
    this.specialAnimation = false,
  });

  FaceExpression copyWith({
    ExpressionType? type,
    double? mouthCurvature,
    double? eyeSize,
    double? eyebrowAngle,
    Color? faceColor,
    bool? specialAnimation,
  }) {
    return FaceExpression(
      type: type ?? this.type,
      mouthCurvature: mouthCurvature ?? this.mouthCurvature,
      eyeSize: eyeSize ?? this.eyeSize,
      eyebrowAngle: eyebrowAngle ?? this.eyebrowAngle,
      faceColor: faceColor ?? this.faceColor,
      specialAnimation: specialAnimation ?? this.specialAnimation,
    );
  }
}

class FaceExpressionNotifier extends StateNotifier<FaceExpression> {
  Timer? _expressionTimer;
  Timer? _randomExpressionTimer;
  Random _random = Random();

  FaceExpressionNotifier()
    : super(
        FaceExpression(
          type: ExpressionType.neutral,
          mouthCurvature: 0.0,
          eyeSize: 1.0,
          eyebrowAngle: 0.0,
          faceColor: Colors.blue.shade300,
        ),
      ) {
    _startRandomExpressions();
  }

  void _startRandomExpressions() {
    _randomExpressionTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_random.nextBool()) {
        _showRandomExpression();
      }
    });
  }

  void _showRandomExpression() {
    final expressions = ExpressionType.values;
    final randomExpression = expressions[_random.nextInt(expressions.length)];
    setExpression(randomExpression);
  }

  void setExpression(ExpressionType expression) {
    // Cancel any ongoing expression timer
    _expressionTimer?.cancel();

    switch (expression) {
      case ExpressionType.neutral:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.0,
          eyeSize: 1.0,
          eyebrowAngle: 0.0,
          faceColor: Colors.blue.shade300,
        );
        break;
      case ExpressionType.happy:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.5,
          eyeSize: 0.8,
          eyebrowAngle: 0.1,
          faceColor: Colors.green.shade300,
        );
        _expressionTimer = Timer(const Duration(seconds: 2), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.surprised:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.0,
          eyeSize: 1.4,
          eyebrowAngle: 0.2,
          faceColor: Colors.purple.shade300,
        );
        _expressionTimer = Timer(const Duration(seconds: 2), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.thinking:
        state = FaceExpression(
          type: expression,
          mouthCurvature: -0.1,
          eyeSize: 0.9,
          eyebrowAngle: 0.15,
          faceColor: Colors.orange.shade300,
          specialAnimation: true,
        );
        _expressionTimer = Timer(const Duration(seconds: 3), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.confused:
        state = FaceExpression(
          type: expression,
          mouthCurvature: -0.2,
          eyeSize: 1.1,
          eyebrowAngle: -0.2,
          faceColor: Colors.yellow.shade300,
        );
        _expressionTimer = Timer(const Duration(seconds: 2), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.wink:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.3,
          eyeSize: 1.0,
          eyebrowAngle: 0.05,
          faceColor: Colors.pink.shade300,
          specialAnimation: true,
        );
        _expressionTimer = Timer(const Duration(milliseconds: 800), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.love:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.4,
          eyeSize: 0.9,
          eyebrowAngle: 0.0,
          faceColor: Colors.red.shade300,
          specialAnimation: true,
        );
        _expressionTimer = Timer(const Duration(seconds: 2), () {
          setExpression(ExpressionType.neutral);
        });
        break;
      case ExpressionType.sleepy:
        state = FaceExpression(
          type: expression,
          mouthCurvature: 0.1,
          eyeSize: 0.6,
          eyebrowAngle: -0.1,
          faceColor: Colors.indigo.shade300,
        );
        _expressionTimer = Timer(const Duration(seconds: 3), () {
          setExpression(ExpressionType.neutral);
        });
        break;
    }
  }

  @override
  void dispose() {
    _expressionTimer?.cancel();
    _randomExpressionTimer?.cancel();
    super.dispose();
  }
}

// Main Robot Face Page
class RobotFacePage extends ConsumerStatefulWidget {
  const RobotFacePage({Key? key}) : super(key: key);

  @override
  ConsumerState<RobotFacePage> createState() => _RobotFacePageState();
}

class _RobotFacePageState extends ConsumerState<RobotFacePage>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _bounceController;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  Timer? _blinkTimer;
  Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Blink animation controller
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Subtle bounce animation for the whole face
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start random blinking
    _scheduleBlink();
  }

  void _scheduleBlink() {
    final nextBlinkDelay = Duration(milliseconds: 1000 + _random.nextInt(4000));
    _blinkTimer = Timer(nextBlinkDelay, () {
      _blink();
      _scheduleBlink();
    });
  }

  void _blink() {
    ref.read(blinkingProvider.notifier).state = true;
    _blinkController.forward().then((_) {
      _blinkController.reverse().then((_) {
        ref.read(blinkingProvider.notifier).state = false;
      });
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _bounceController.dispose();
    _floatController.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + _bounceController.value * 0.02,
                        child: RobotFace(blinkController: _blinkController),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  for (final expression in ExpressionType.values)
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(faceExpressionProvider.notifier)
                            .setExpression(expression);
                      },
                      child: Text(expression.name.toUpperCase()),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Robot Face Widget
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
          BoxShadow(
            color: expression.faceColor.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Face features container
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(faceSize * 0.1),
              child: Stack(
                children: [
                  // Eyes row
                  Positioned(
                    top: faceSize * 0.2,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Left eye with eyebrow
                        Column(
                          children: [
                            // Left eyebrow
                            Transform.rotate(
                              angle: expression.eyebrowAngle,
                              child: Container(
                                width: faceSize * 0.18,
                                height: faceSize * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(
                                    faceSize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: faceSize * 0.02),
                            // Left eye
                            _buildEye(
                              context,
                              faceSize,
                              expression,
                              isBlinking,
                              isLeftEye: true,
                            ),
                          ],
                        ),
                        // Right eye with eyebrow
                        Column(
                          children: [
                            // Right eyebrow
                            Transform.rotate(
                              angle: -expression.eyebrowAngle,
                              child: Container(
                                width: faceSize * 0.18,
                                height: faceSize * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(
                                    faceSize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: faceSize * 0.02),
                            // Right eye
                            _buildEye(
                              context,
                              faceSize,
                              expression,
                              isBlinking,
                              isLeftEye: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Mouth
                  Positioned(
                    bottom: faceSize * 0.15,
                    left: faceSize * 0.15,
                    right: faceSize * 0.15,
                    child: _buildMouth(context, faceSize, expression),
                  ),

                  // Special animations
                  if (expression.specialAnimation)
                    _buildSpecialAnimation(context, faceSize, expression),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEye(
    BuildContext context,
    double faceSize,
    FaceExpression expression,
    bool isBlinking, {
    required bool isLeftEye,
  }) {
    // For wink expression, only close one eye
    final shouldClose =
        isBlinking ||
        (expression.type == ExpressionType.wink && !isLeftEye) ||
        expression.type == ExpressionType.sleepy;

    // For love expression, show heart eyes
    if (expression.type == ExpressionType.love) {
      return Container(
        width: faceSize * 0.18 * expression.eyeSize,
        height: faceSize * 0.18 * expression.eyeSize,
        child: CustomPaint(painter: HeartPainter(color: Colors.red)),
      );
    }

    return AnimatedBuilder(
      animation: blinkController,
      builder: (context, child) {
        double blinkValue = shouldClose ? blinkController.value : 0.0;

        if (expression.type == ExpressionType.sleepy) {
          blinkValue = 0.7; // Half-closed eyes for sleepy
        }

        return Container(
          width: faceSize * 0.18 * expression.eyeSize,
          height: faceSize * 0.18 * expression.eyeSize * (1.0 - blinkValue),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black87, width: 2),
          ),
          child: Center(
            child: Container(
              width: faceSize * 0.08 * expression.eyeSize,
              height: faceSize * 0.08 * expression.eyeSize * (1.0 - blinkValue),
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMouth(
    BuildContext context,
    double faceSize,
    FaceExpression expression,
  ) {
    // Different mouth styles based on expression
    switch (expression.type) {
      case ExpressionType.surprised:
        // O-shaped mouth for surprised
        return Container(
          width: faceSize * 0.2,
          height: faceSize * 0.2,
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
        );
      case ExpressionType.thinking:
        // Offset small line for thinking
        return Align(
          alignment: Alignment(0.3, 0),
          child: Container(
            width: faceSize * 0.15,
            height: faceSize * 0.04,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(faceSize * 0.02),
            ),
          ),
        );
      default:
        // Default curved mouth
        return CustomPaint(
          size: Size(faceSize * 0.4, faceSize * 0.2),
          painter: MouthPainter(curvature: expression.mouthCurvature),
        );
    }
  }

  Widget _buildSpecialAnimation(
    BuildContext context,
    double faceSize,
    FaceExpression expression,
  ) {
    switch (expression.type) {
      case ExpressionType.thinking:
        // Thinking bubbles
        return Positioned(
          top: faceSize * 0.1,
          right: faceSize * 0.1,
          child: Column(
            children: [
              Container(
                width: faceSize * 0.06,
                height: faceSize * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: faceSize * 0.01),
              Container(
                width: faceSize * 0.08,
                height: faceSize * 0.08,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: faceSize * 0.01),
              Container(
                width: faceSize * 0.1,
                height: faceSize * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      case ExpressionType.love:
        // Floating hearts around the face
        return Positioned.fill(
          child: Stack(
            children: List.generate(8, (index) {
              final random = Random(index);
              return Positioned(
                top: random.nextDouble() * faceSize * 0.8,
                left: random.nextDouble() * faceSize * 0.8,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: 1 + random.nextInt(2)),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, -50 * value),
                      child: Opacity(
                        opacity: 1 - value,
                        child: Container(
                          width: faceSize * 0.08,
                          height: faceSize * 0.08,
                          child: CustomPaint(
                            painter: HeartPainter(
                              color: Colors.red.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}

// Custom Painters

class MouthPainter extends CustomPainter {
  final double
  curvature; // -1.0 to 1.0, where -1.0 is sad, 0.0 is neutral, 1.0 is happy

  MouthPainter({required this.curvature});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.height * 0.15
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    // Control points for the curve
    final controlY = size.height * 0.5 - size.height * curvature;

    path.quadraticBezierTo(
      size.width * 0.5,
      controlY * 2,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

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
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height * 0.3);

    // Left curve
    path.cubicTo(
      width * 0.2,
      height * 0.1,
      -width * 0.25,
      height * 0.6,
      width / 2,
      height,
    );

    // Right curve
    path.cubicTo(
      width * 1.25,
      height * 0.6,
      width * 0.8,
      height * 0.1,
      width / 2,
      height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
