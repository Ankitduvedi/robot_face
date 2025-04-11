import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:permission_handler/permission_handler.dart';

class WakeWordDetector extends StatefulWidget {
  const WakeWordDetector({super.key});

  @override
  WakeWordDetectorState createState() => WakeWordDetectorState();
}

class WakeWordDetectorState extends State<WakeWordDetector> {
  PorcupineManager? _porcupineManager;
  bool _isListening = false;
  String _detectionStatus = "Waiting to start";

  @override
  void initState() {
    super.initState();
    _initWakeWordDetection();
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<void> _initWakeWordDetection() async {
    // Request microphone permission
    if (!await requestMicrophonePermission()) {
      setState(() {
        _detectionStatus = "Microphone permission denied";
      });
      return;
    }

    try {
      // Get your access key from Picovoice Console
      final String accessKey = "I9YLUI5WqVtMrIVxcgzZdELp9CB8QZSHYKKtmK6fu0mJg63A/Kk1Bw==";

      // First, we need to load the custom wake word file from assets
      final customWakeWordPath = await _extractAssetFile(
        'assets/wake_words/custom_wake_word.ppn',
      );

      // Initialize with the custom wake word
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        accessKey,
        [customWakeWordPath],
        _wakeWordCallback,
        modelPath: null, // Use default model
        sensitivities: [0.7], // Adjust sensitivity between 0-1
        errorCallback: _errorCallback,
      );

      setState(() {
        _detectionStatus = "Custom wake word initialized successfully";
      });
    } catch (ex) {
      log("Initialization error: $ex");
      setState(() {
        _detectionStatus = "Failed to initialize: $ex";
      });
    }
  }

  // Helper function to extract asset file to a path that can be read by Porcupine
  Future<String> _extractAssetFile(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final String tempPath =
          '${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}';
      final File file = File(tempPath);
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      return tempPath;
    } catch (e) {
      throw Exception('Failed to extract asset file: $e');
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    setState(() {
      _detectionStatus = "Custom wake word detected!";
    });

    // Perform actions when wake word is detected
    _startVoiceCommandSession();
  }

  void _errorCallback(PorcupineException error) {
    setState(() {
      _detectionStatus = "Error: ${error.message}";
    });
  }

  void _startVoiceCommandSession() {
    // Implement your voice command logic here
    log("Voice command session started");
  }

  void _toggleListening() async {
    if (_isListening) {
      await _porcupineManager?.stop();
      setState(() {
        _isListening = false;
        _detectionStatus = "Stopped listening";
      });
    } else {
      try {
        await _porcupineManager?.start();
        setState(() {
          _isListening = true;
          _detectionStatus = "Listening for custom wake word...";
        });
      } catch (ex) {
        setState(() {
          _detectionStatus = "Failed to start: $ex";
        });
      }
    }
  }

  @override
  void dispose() {
    _porcupineManager?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_detectionStatus, style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _toggleListening,
          child: Text(_isListening ? "Stop Listening" : "Start Listening"),
        ),
      ],
    );
  }
}
