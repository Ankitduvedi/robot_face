import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/gemeni_ai_agent/controller/gemini_controller.dart';
import 'package:robot_display_v2/server/camera_feed_server.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreens extends ConsumerStatefulWidget {
  const ChatScreens({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreens> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
    // Start listening when app opens
    Future.delayed(Duration(seconds: 1), () {
      _startListening();
    });
  }

  void _initializeSpeech() async {
    _speech = stt.SpeechToText();
    await _speech.initialize();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setSpeechRate(0.5);

    // Listen for TTS completion
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
      // Start listening after response is spoken
      _startListening();
    });

    // Set progress handler to track speaking state
    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });
  }

  Future<void> _speak(String text) async {
    if (_isListening) {
      await _stopListening();
    }
    await _flutterTts.speak(text);
  }

  Future<void> _startListening() async {
    log("in start listening");
    if (!_isListening && !_isSpeaking) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        try {
          await _speech.listen(
            onResult: (result) {
              if (result.finalResult) {
                setState(() => _isListening = false);
                if (result.recognizedWords.isNotEmpty) {
                  log('Recognized: ${result.recognizedWords}');
                  _handleSubmitted(result.recognizedWords);
                } else {
                  _startListening(); // Retry if no words recognized
                }
              }
            },

            listenOptions: stt.SpeechListenOptions(
              listenMode: stt.ListenMode.confirmation,
              cancelOnError: true,
              partialResults: false,
            ),
          );
        } catch (e) {
          log('Error listening: $e');
          _startListening(); // Retry on error
        }
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _handleSubmitted(String text) async {
    log("in handle submitted");
    if (text.isEmpty) return;
    log('User input: $text');
    _textController.clear();

    final config = {"prompt": text, "max_tokens": 1000};
    final response = ref
        .read(gemeniControllerProvider.notifier)
        .sendDataToGemini(config, context)
        .then((response) {
          log("Response from Gemini: $response");
          if (response.isNotEmpty) {
            _speak(response);
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        })
        .catchError((error) {
          log("Error from Gemini: $error");
          setState(() {
            _isLoading = false;
          });
        });
  }

  Widget _buildStatusText() {
    if (_isSpeaking)
      return Text('Speaking...', style: TextStyle(color: Colors.blue));
    if (_isListening)
      return Text('Listening...', style: TextStyle(color: Colors.green));
    if (_isLoading)
      return Text('Processing...', style: TextStyle(color: Colors.orange));
    return Text('Tap mic to start', style: TextStyle(color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 30,
                      ),
                      color: _isListening ? Colors.red : Colors.blue,
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: Align(
              alignment: Alignment.center,
              child:
                  CameraFeedServer(), // Ensure BellaBotFace always remains centered
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }
}
