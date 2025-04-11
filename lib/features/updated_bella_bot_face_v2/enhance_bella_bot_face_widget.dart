// lib/widgets/enhanced_bellabot_face.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/audio_visualiser.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_face_painter.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_provider.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/particle_system.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/speech_and_thought_buuble.dart';
import './enhanced_bella_bot_eye.dart';

class EnhancedBellaBotFace extends ConsumerStatefulWidget {
  const EnhancedBellaBotFace({Key? key}) : super(key: key);

  @override
  _EnhancedBellaBotFaceState createState() => _EnhancedBellaBotFaceState();
}

class _EnhancedBellaBotFaceState extends ConsumerState<EnhancedBellaBotFace>
    with TickerProviderStateMixin {
  // Constants for screen dimensions - replace with actual dimensions in a real app
  late double screenWidth;
  late double screenHeight;

  // Accelerometer subscription for tilt detection
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _setupDeviceMotionListener();
  }

  void _setupDeviceMotionListener() {
    // In a real app, you would use the accelerometer package:
    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   ref.read(deviceMotionProvider.notifier).state = DeviceMotionData(
    //     tiltX: event.x,
    //     tiltY: event.y,
    //     tiltZ: event.z,
    //     isShaking: event.x.abs() + event.y.abs() + event.z.abs() > 15,
    //   );
    // });

    // For this demo, we'll simulate device motion with a timer
    Timer.periodic(const Duration(milliseconds: 100), (_) {
      final random = Random();
      final time = DateTime.now().millisecondsSinceEpoch / 1000;

      // Simulate gentle device movement
      ref.read(deviceMotionProvider.notifier).state = DeviceMotionData(
        tiltX: sin(time * 0.5) * 0.5 + (random.nextDouble() - 0.5) * 0.2,
        tiltY: cos(time * 0.7) * 0.3 + (random.nextDouble() - 0.5) * 0.2,
        tiltZ: 0,
        isShaking: random.nextDouble() > 0.97, // Occasional shake
        lightIntensity: 0.5 + sin(time * 0.1) * 0.2,
      );
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    final expression = ref.watch(bellaBotExpressionProvider);
    final animationState = ref.watch(animationStateProvider);
    final themeData = ref.watch(themeDataProvider);
    final skin = ref.watch(characterSkinProvider);
    final bubbleState = ref.watch(bubbleProvider);
    final particleEffects = ref.watch(particleEffectsProvider);
    final audioData = ref.watch(audioVisualizerProvider);

    // Apply animation to position based on device motion
    final deviceMotion = ref.watch(deviceMotionProvider);
    final motionOffset = Offset(
      deviceMotion.tiltX * 5.0,
      deviceMotion.tiltY * 5.0,
    );

    // Calculate animated values for visual effects
    final floatValue =
        animationState.isFloating ? animationState.floatValue * 5.0 : 0.0;

    final bounceScale =
        animationState.isBouncing
            ? 1.0 + (animationState.bounceValue * 0.03)
            : 1.0;

    final glowIntensity =
        animationState.isGlowing
            ? expression.glowIntensity * (0.8 + animationState.glowValue * 0.4)
            : expression.glowIntensity * 0.5;

    return Stack(
      children: [
        // Particle effects behind the face
        if (particleEffects.isNotEmpty)
          Positioned.fill(
            child: ParticleSystem(
              effects: particleEffects,
              size: Size(screenWidth, screenHeight),
              isActive: true,
            ),
          ),

        // Add speech/thought bubbles if needed
        if (bubbleState.showSpeechBubble)
          Positioned(
            left: bubbleState.speechBubblePosition.dx,
            top: bubbleState.speechBubblePosition.dy,
            child: BubbleWidget(
              text: bubbleState.speechBubbleText,
              type: BubbleType.speech,
              emojis: bubbleState.emojis,
              backgroundColor: themeData.primaryColor,
              textColor: Colors.black,
              scale: 1.0 + sin(animationState.bounceValue * pi) * 0.05,
            ),
          ),

        if (bubbleState.showThoughtBubble)
          Positioned(
            left: bubbleState.thoughtBubblePosition.dx,
            top: bubbleState.thoughtBubblePosition.dy,
            child: BubbleWidget(
              text: bubbleState.thoughtBubbleText,
              type: BubbleType.thought,
              emojis: bubbleState.emojis,
              backgroundColor: themeData.primaryColor,
              textColor: Colors.black,
              scale: 1.0 + sin(animationState.bounceValue * pi) * 0.05,
            ),
          ),

        // Add audio visualization if listening/processing
        if (audioData.isActive)
          Positioned(
            bottom: screenHeight * 0.3,
            left: screenWidth * 0.5 - 75,
            child: AudioVisualizer(
              audioData: audioData,
              color: themeData.accentColor,
              height: 50,
              width: 150,
              isListening: expression.type == ExpressionType.listening,
              isProcessing: expression.type == ExpressionType.processing,
            ),
          ),

        // The actual face with animation effects
        Center(
          child: Transform.translate(
            offset: Offset(motionOffset.dx, motionOffset.dy + floatValue),
            child: Transform.scale(
              scale: bounceScale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect behind the face
                  if (glowIntensity > 0)
                    CustomPaint(
                      size: Size(screenWidth * 0.9, screenHeight * 0.4),
                      painter: GlowPainter(
                        color: expression.glowColor,
                        intensity: glowIntensity,
                        animationValue: animationState.glowValue,
                      ),
                    ),

                  // Main face container
                  Container(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      color: expression.faceColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                      // Add gradient for more depth
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -0.2),
                        radius: 0.9,
                        colors: [
                          expression.faceColor.withOpacity(1.0),
                          expression.faceColor.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),

                  // Face elements
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Facial accessories (first, as background)
                      if (expression.accessory != AccessoryType.none)
                        CustomPaint(
                          size: Size(screenWidth * 0.8, screenWidth * 0.8),
                          painter: AccessoryPainter(
                            accessory: expression.accessory,
                            color: themeData.primaryColor,
                            accentColor: themeData.accentColor,
                            animationValue: animationState.accessoryValue,
                          ),
                        ),

                      // Left Eyebrow
                      SizedBox(
                        height: screenWidth / 30,
                        width: screenWidth / 2,
                        child: CustomPaint(
                          painter: EnhancedEyebrowPainter(
                            isLeft: true,
                            offset: expression.leftEyebrowOffset,
                            skin: skin,
                            color: themeData.primaryColor,
                            thickness: 30.0,
                            isAnimated: true,
                            animationValue: animationState.bounceValue,
                          ),
                        ),
                      ),

                      // Right Eyebrow
                      SizedBox(
                        height: screenWidth / 30,
                        width: screenWidth / 2,
                        child: CustomPaint(
                          painter: EnhancedEyebrowPainter(
                            isLeft: false,
                            offset: expression.rightEyebrowOffset,
                            skin: skin,
                            color: themeData.primaryColor,
                            thickness: 30.0,
                            isAnimated: true,
                            animationValue: animationState.bounceValue,
                          ),
                        ),
                      ),

                      // Eyes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left Eye
                          EnhancedBellaBotEye(
                            isLeft: true,
                            openness: 1.0,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            skin: skin,
                          ),
                          SizedBox(width: 120),
                          // Right Eye
                          EnhancedBellaBotEye(
                            isLeft: false,
                            openness: 1.0,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            skin: skin,
                          ),
                        ],
                      ),

                      // Mouth and other facial elements
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Nose
                          Container(
                            width: screenWidth / 35,
                            height: screenWidth / 40,
                            decoration: BoxDecoration(
                              color: themeData.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight / 50),

                          // Mouth
                          SizedBox(
                            height: screenWidth / 30,
                            width: screenWidth / 2,
                            child: CustomPaint(
                              painter: EnhancedMouthPainter(
                                curvature: expression.mouthCurvature,
                                skin: skin,
                                color: themeData.primaryColor,
                                animationValue: animationState.bounceValue,
                                isAnimated: true,
                                expressionType: expression.type,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight / 5.2),
                        ],
                      ),

                      // Blush (conditionally shown)
                      if (expression.hasBlush)
                        SizedBox(
                          width: screenWidth,
                          height: screenHeight / 2,
                          child: CustomPaint(
                            painter: BlushPainter(
                              color: Colors.pink,
                              size: 1.0,
                              skin: skin,
                              animationValue: animationState.bounceValue,
                              isAnimated: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    // TODO: implement createTicker
    throw UnimplementedError();
  }
}
