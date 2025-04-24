class RawTextAnalysisRequest {
  final String text;
  final String tone;
  final bool generateAudio;

  RawTextAnalysisRequest({
    required this.text,
    required this.tone,
    this.generateAudio = false,
  });

  Map<String, dynamic> toJson() {
    return {'text': text, 'tone': tone, 'generate_audio': generateAudio};
  }
}
