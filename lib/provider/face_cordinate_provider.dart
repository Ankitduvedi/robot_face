import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:robot_display_v2/data/model/face_ccordinate_model.dart';

class FaceCoordinatesNotifier extends StateNotifier<List<FaceCoordinate>> {
  FaceCoordinatesNotifier() : super([]);

  void updateFaceCoordinates(List<FaceCoordinate> newCoordinates) {
    state = newCoordinates;
  }
}

final faceCoordinatesProvider =
    StateNotifierProvider<FaceCoordinatesNotifier, List<FaceCoordinate>>((ref) {
      return FaceCoordinatesNotifier();
    });
