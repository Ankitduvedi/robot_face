import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:robot_display_v2/data/const.dart';
import 'package:robot_display_v2/data/model/face_ccordinate_model.dart';
import 'package:robot_display_v2/main.dart';
import 'package:robot_display_v2/provider/face_cordinate_provider.dart';
import 'package:robot_display_v2/screen/pudu_bot_face_animation%20copy.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CameraFeedServer extends ConsumerStatefulWidget {
  const CameraFeedServer({super.key});

  @override
  CameraFeedServerState createState() => CameraFeedServerState();
}

class CameraFeedServerState extends ConsumerState<CameraFeedServer> {
  CameraController? _cameraController;
  bool _isSending = false;
  late Timer _timer;
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speechToText = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() async {
    await speechToText.initialize();
  }

  void _initializeCamera() async {
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {});

    // Send frames every second (adjust interval as needed)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isSending) {
        _isSending = true;
        _captureAndSendFrame();
      }
    });
  }

  Future<void> _captureAndSendFrame() async {
    try {
      final image = await _cameraController!.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      // Send the image to the server
      await _sendImageToServer(imageBytes);
    } catch (e) {
      log("Error capturing image: $e");
    }
    _isSending = false;
  }

  Future<void> _sendImageToServer(Uint8List imageBytes) async {
    String serverUrl = "$url/detect"; // Replace with your server URL

    try {
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'frame.jpg',
        ),
      );
      log("Sending image data of length: ${imageBytes.length}");

      // Send the request and get response
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        log("Face detection response: $responseData");

        final List<dynamic> decodedData = json.decode(responseData);
        List<FaceCoordinate> faceCoordinates =
            decodedData.map((data) {
              return FaceCoordinate(
                x: data['x'],
                y: data['y'],
                width: data['width'],
                height: data['height'],
              );
            }).toList();

        ref
            .read(faceCoordinatesProvider.notifier)
            .updateFaceCoordinates(faceCoordinates);
      } else {
        log("Face detection failed with status code ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending image: $e");
    }
  }

  // Future<String> takeVoiceInput() async {
  //   bool isAvailable = await speechToText.initialize();
  //   if (isAvailable) {
  //     await speechToText.listen();
  //     await Future.delayed(Duration(seconds: 3));
  //     await speechToText.stop();
  //     if (speechToText.lastRecognizedWords.isNotEmpty) {
  //       return speechToText.lastRecognizedWords;
  //     }
  //   }
  //   return "";
  // }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController!.value.isInitialized) {
      return Container(color: Colors.black);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: BellaBotFace()),
    );
  }
}
