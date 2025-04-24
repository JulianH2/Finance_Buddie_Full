class FinancialChatRequest {
  final String message;
  final String tone;
  final bool generateAudioResponse;
  final List<Map<String, dynamic>> chatHistory;

  FinancialChatRequest({
    required this.message,
    required this.tone,
    this.generateAudioResponse = false,
    this.chatHistory = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'tone': tone,
      'generate_audio_response': generateAudioResponse,
      'chat_history': chatHistory,
    };
  }
}
