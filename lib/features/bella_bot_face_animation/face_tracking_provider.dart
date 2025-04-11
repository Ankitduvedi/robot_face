// lib/providers/face_tracking_provider.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_face_animation_modal.dart';

// In a real application, this would connect to a camera and facial detection system
// For this demo, we'll use a simulated face position

final faceTrackingProvider =
    StateNotifierProvider<FaceTrackingNotifier, List<FaceCoordinate>>((ref) {
      return FaceTrackingNotifier();
    });

class FaceTrackingNotifier extends StateNotifier<List<FaceCoordinate>> {
  Timer? _simulationTimer;
  final Random _random = Random();

  // Current position for smooth movement
  double _currentX = 200.0;
  double _currentY = 300.0;

  // Target position for simulation
  double _targetX = 200.0;
  double _targetY = 300.0;

  FaceTrackingNotifier() : super([]) {
    // Initialize with a face in the center
    state = [
      FaceCoordinate(x: _currentX, y: _currentY, width: 100, height: 120),
    ];

    _startSimulation();
  }

  void _startSimulation() {
    // Update target position every few seconds
    Timer.periodic(const Duration(seconds: 4), (timer) {
      // Randomize a new target with some constraints to keep on screen
      _targetX = 100.0 + _random.nextDouble() * 200.0;
      _targetY = 150.0 + _random.nextDouble() * 300.0;
    });

    // Smoothly animate current position towards target
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      // Ease towards target position
      _currentX += (_targetX - _currentX) * 0.05;
      _currentY += (_targetY - _currentY) * 0.05;

      // Update the face coordinate
      state = [
        FaceCoordinate(x: _currentX, y: _currentY, width: 100, height: 120),
      ];
    });
  }

  // Manual control for testing - this would connect to actual face detection
  void updateFacePosition(double x, double y) {
    _targetX = x;
    _targetY = y;
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
