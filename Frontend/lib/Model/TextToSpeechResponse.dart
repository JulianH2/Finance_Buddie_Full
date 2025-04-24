import 'package:finance_buddie/Model/AudioInfo.dart' show AudioInfo;

class TextToSpeechResponse {
  final String status;
  final String textSample;
  final AudioInfo audioInfo;
  final String user;

  TextToSpeechResponse({
    required this.status,
    required this.textSample,
    required this.audioInfo,
    required this.user,
  });

  factory TextToSpeechResponse.fromJson(Map<String, dynamic> json) {
    return TextToSpeechResponse(
      status: json['status'],
      textSample: json['text_sample'],
      audioInfo: AudioInfo.fromJson(json['audio_info']),
      user: json['user'],
    );
  }
}
