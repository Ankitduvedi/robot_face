import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  if (!status.isGranted) {
    status = await Permission.microphone.request();
  }
  return status.isGranted;
}