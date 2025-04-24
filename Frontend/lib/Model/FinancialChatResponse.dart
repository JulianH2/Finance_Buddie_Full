import 'package:finance_buddie/Model/AudioInfo.dart';
import 'package:finance_buddie/Model/Metadata.dart';

class FinancialChatResponse {
  final String status;
  final String? response;
  final AudioInfo? audioResponse;
  final List<Map<String, dynamic>> chatHistory;
  final Metadata metadata;

  FinancialChatResponse({
    required this.status,
    this.response,
    this.audioResponse,
    required this.chatHistory,
    required this.metadata,
  });

  factory FinancialChatResponse.fromJson(Map<String, dynamic> json) {
    return FinancialChatResponse(
      status: json['status'] as String,
      response: json['response'] as String?,
      chatHistory: List<Map<String, dynamic>>.from(json['chat_history']),
      metadata: Metadata.fromJson(json['metadata']),
    );
  }
}
