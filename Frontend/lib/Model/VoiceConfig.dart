class VoiceConfig {
  final String tone;
  final String voiceModel;
  final String openaiVoice;
  final double speed;
  final double pitch;

  VoiceConfig({
    required this.tone,
    required this.voiceModel,
    required this.openaiVoice,
    required this.speed,
    required this.pitch,
  });

  factory VoiceConfig.fromJson(Map<String, dynamic> json) {
    return VoiceConfig(
      tone: json['tone'],
      voiceModel: json['voice_model'],
      openaiVoice: json['openai_voice'],
      speed: (json['speed'] as num).toDouble(),
      pitch: (json['pitch'] as num).toDouble(),
    );
  }
}
