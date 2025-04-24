import 'package:finance_buddie/Model/RegisterResponse.dart';

class FinancialAnalysisRequest {
  final String tone;
  final bool generateAudio;
  final List<Transaction> transactions;

  FinancialAnalysisRequest({
    required this.tone,
    required this.generateAudio,
    required this.transactions,
  });

  Map<String, dynamic> toJson() {
    return {
      'tone': tone,
      'generate_audio': generateAudio,
      'transactions': transactions.map((tx) => tx.toJson()).toList(),
    };
  }
}
