import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

// Enums for different facial expressions
enum FacialExpression {
  neutral,
  happy,
  sad,
  surprised,
  angry,
  thinking,
  sleeping,
}

// Provider for the current facial expression
final facialExpressionProvider =
    StateNotifierProvider<FacialExpressionNotifier, FacialExpression>((ref) {
      return FacialExpressionNotifier();
    });

class FacialExpressionNotifier extends StateNotifier<FacialExpression> {
  FacialExpressionNotifier() : super(FacialExpression.neutral);

  void setExpression(FacialExpression expression) {
    state = expression;
  }

  void randomExpression() {
    final expressions = FacialExpression.values;
    final random = math.Random();
    state = expressions[random.nextInt(expressions.length)];
  }
}

// Provider for eye blinking state
final eyeBlinkProvider = StateNotifierProvider<EyeBlinkNotifier, bool>((ref) {
  return EyeBlinkNotifier();
});

class EyeBlinkNotifier extends StateNotifier<bool> {
  EyeBlinkNotifier() : super(false);

  void blink() => state = true;
  void open() => state = false;
}

// class RobotFaceApp extends StatelessWidget {
//   const RobotFaceApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Robot Face',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blue,
//       ),
//       home: const RobotFacePage(),
//     );
//   }
// }

class RobotFacePage extends ConsumerStatefulWidget {
  const RobotFacePage({Key? key}) : super(key: key);

  @override
  ConsumerState<RobotFacePage> createState() => _RobotFacePageState();
}

class _RobotFacePageState extends ConsumerState<RobotFacePage>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _expressionController;

  @override
  void initState() {
    super.initState();

    // Set up blinking animation controller
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _blinkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _blinkController.reverse();
        ref.read(eyeBlinkProvider.notifier).open();
      }
    });

    // Set up expression animation controller
    _expressionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Start periodic blinking
    _setupPeriodicBlinking();

    // Change expressions periodically (for demo)
    _setupPeriodicExpressionChanges();
  }

  void _setupPeriodicBlinking() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(eyeBlinkProvider.notifier).blink();
        _blinkController.forward();
        _setupPeriodicBlinking();
      }
    });
  }

  void _setupPeriodicExpressionChanges() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        ref.read(facialExpressionProvider.notifier).randomExpression();
        _expressionController.reset();
        _expressionController.forward();
        _setupPeriodicExpressionChanges();
      }
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 4),
            ),
            padding: const EdgeInsets.all(16),
            child: RobotFace(
              blinkController: _blinkController,
              expressionController: _expressionController,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(facialExpressionProvider.notifier).randomExpression();
          _expressionController.reset();
          _expressionController.forward();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class RobotFace extends ConsumerWidget {
  final AnimationController blinkController;
  final AnimationController expressionController;

  const RobotFace({
    Key? key,
    required this.blinkController,
    required this.expressionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlinking = ref.watch(eyeBlinkProvider);
    final expression = ref.watch(facialExpressionProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Robot eyes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            EyeWidget(
              isBlinking: isBlinking,
              blinkController: blinkController,
              expression: expression,
              isLeft: true,
            ),
            EyeWidget(
              isBlinking: isBlinking,
              blinkController: blinkController,
              expression: expression,
              isLeft: false,
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Robot mouth
        MouthWidget(
          expression: expression,
          animationController: expressionController,
        ),
      ],
    );
  }
}

class EyeWidget extends StatelessWidget {
  final bool isBlinking;
  final AnimationController blinkController;
  final FacialExpression expression;
  final bool isLeft;

  const EyeWidget({
    Key? key,
    required this.isBlinking,
    required this.blinkController,
    required this.expression,
    required this.isLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: blinkController, curve: Curves.easeInOut),
    );

    // Determine eye shape based on expression
    Color eyeColor = Colors.blue;
    double eyeWidth = 60;
    double eyeHeight = 60;
    BorderRadius eyeBorderRadius = BorderRadius.circular(30);

    switch (expression) {
      case FacialExpression.angry:
        eyeBorderRadius =
            isLeft
                ? const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
                : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                );
        eyeColor = Colors.red;
        break;
      case FacialExpression.sad:
        eyeColor = Colors.lightBlue;
        break;
      case FacialExpression.happy:
        eyeBorderRadius = BorderRadius.circular(20);
        eyeWidth = 50;
        eyeHeight = 50;
        break;
      case FacialExpression.surprised:
        eyeBorderRadius = BorderRadius.circular(40);
        eyeWidth = 70;
        eyeHeight = 70;
        eyeColor = Colors.cyan;
        break;
      case FacialExpression.thinking:
        if (isLeft) {
          eyeWidth = 40;
          eyeHeight = 70;
        } else {
          eyeWidth = 70;
          eyeHeight = 40;
        }
        eyeBorderRadius = BorderRadius.circular(20);
        eyeColor = Colors.lightBlueAccent;
        break;
      case FacialExpression.sleeping:
        eyeHeight = 10;
        eyeWidth = 60;
        eyeBorderRadius = BorderRadius.circular(5);
        eyeColor = Colors.blueGrey;
        break;
      case FacialExpression.neutral:
      default:
        // Default settings
        break;
    }

    return AnimatedBuilder(
      animation: blinkAnimation,
      builder: (context, child) {
        return Container(
          width: eyeWidth,
          height: eyeHeight * blinkAnimation.value,
          decoration: BoxDecoration(
            color: eyeColor,
            borderRadius: eyeBorderRadius,
            boxShadow: [
              BoxShadow(
                color: eyeColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MouthWidget extends StatelessWidget {
  final FacialExpression expression;
  final AnimationController animationController;

  const MouthWidget({
    Key? key,
    required this.expression,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    // Mouth properties based on expression
    double mouthWidth = 120;
    double mouthHeight = 20;
    Color mouthColor = Colors.blue;
    BorderRadius mouthBorderRadius = BorderRadius.circular(10);
    Widget? customMouth;

    switch (expression) {
      case FacialExpression.happy:
        customMouth = AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(120, 60),
              painter: HappyMouthPainter(
                progress: animation.value,
                color: Colors.blue,
              ),
            );
          },
        );
        break;
      case FacialExpression.sad:
        customMouth = AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(120, 60),
              painter: SadMouthPainter(
                progress: animation.value,
                color: Colors.lightBlue,
              ),
            );
          },
        );
        break;
      case FacialExpression.surprised:
        mouthWidth = 60;
        mouthHeight = 60;
        mouthBorderRadius = BorderRadius.circular(30);
        mouthColor = Colors.cyan;
        break;
      case FacialExpression.angry:
        customMouth = AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(120, 40),
              painter: AngryMouthPainter(
                progress: animation.value,
                color: Colors.red,
              ),
            );
          },
        );
        break;
      case FacialExpression.thinking:
        mouthWidth = 40;
        mouthHeight = 15;
        mouthBorderRadius = BorderRadius.circular(8);
        mouthColor = Colors.lightBlueAccent;
        break;
      case FacialExpression.sleeping:
        customMouth = AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(100, 40),
              painter: SleepingMouthPainter(
                progress: animation.value,
                color: Colors.blueGrey,
              ),
            );
          },
        );
        break;
      case FacialExpression.neutral:
      default:
        // Default mouth
        break;
    }

    if (customMouth != null) {
      return customMouth;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: mouthWidth,
          height: mouthHeight,
          decoration: BoxDecoration(
            color: mouthColor,
            borderRadius: mouthBorderRadius,
            boxShadow: [
              BoxShadow(
                color: mouthColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom painters for different mouth expressions
class HappyMouthPainter extends CustomPainter {
  final double progress;
  final Color color;

  HappyMouthPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * (0.3 + (0.7 * progress)),
      size.width,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SadMouthPainter extends CustomPainter {
  final double progress;
  final Color color;

  SadMouthPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * (0.7 - (0.4 * progress)),
      size.width,
      size.height * 0.7,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AngryMouthPainter extends CustomPainter {
  final double progress;
  final Color color;

  AngryMouthPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * (0.8 * progress),
      size.width,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SleepingMouthPainter extends CustomPainter {
  final double progress;
  final Color color;

  SleepingMouthPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    // Draw a wavy "Zzz" line
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final startX = size.width * 0.2 + (i * 20 * progress);
      final startY = size.height * 0.5 + (i * 10 * progress);

      path.moveTo(startX, startY);
      path.lineTo(startX + 15 * progress, startY - 10 * progress);
      path.lineTo(startX + 30 * progress, startY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
