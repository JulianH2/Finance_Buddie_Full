class TextToSpeechRequest {
  final String text;
  final String tone;

  TextToSpeechRequest({required this.text, required this.tone});

  Map<String, dynamic> toJson() {
    return {'text': text, 'tone': tone};
  }
}
