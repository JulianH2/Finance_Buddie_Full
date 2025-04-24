import 'package:finance_buddie/Model/VoiceConfig.dart';

class AudioInfo {
  final String audioUrl;
  final String expiresAt;
  final String filename;
  final int size;
  final String status;
  final VoiceConfig voiceConfig;

  AudioInfo({
    required this.audioUrl,
    required this.expiresAt,
    required this.filename,
    required this.size,
    required this.status,
    required this.voiceConfig,
  });

  factory AudioInfo.fromJson(Map<String, dynamic> json) {
    return AudioInfo(
      audioUrl: json['audio_url'],
      expiresAt: json['expires_at'],
      filename: json['filename'],
      size: json['size'],
      status: json['status'],
      voiceConfig: VoiceConfig.fromJson(json['voice_config']),
    );
  }
}
