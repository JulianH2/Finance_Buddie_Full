import 'package:finance_buddie/Model/AudioInfo.dart';
import 'package:finance_buddie/Model/Metadata.dart';
import 'package:finance_buddie/Model/Summary.dart';

class FinancialAnalysisResponse {
  final String status;
  final String user;
  final String analysisDate;
  final Summary summary;
  final String message;
  final AudioInfo? audioInfo;
  final Metadata metadata;

  FinancialAnalysisResponse({
    required this.status,
    required this.user,
    required this.analysisDate,
    required this.summary,
    required this.message,
    this.audioInfo,
    required this.metadata,
  });

  factory FinancialAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return FinancialAnalysisResponse(
      status: json['status'],
      user: json['user'],
      analysisDate: json['analysis_date'],
      summary: Summary.fromJson(json['summary']),
      message: json['message'],
      audioInfo:
          json['audio_info'] != null
              ? AudioInfo.fromJson(json['audio_info'])
              : null,
      metadata: Metadata.fromJson(json['metadata']),
    );
  }
  
}




