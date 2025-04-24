import 'dart:async';
import 'package:finance_buddie/Model/TextToSpeechRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:finance_buddie/Model/FinancialAnalysisRequest.dart';
import 'package:finance_buddie/Model/FinancialAnalysisResponse.dart';
import 'package:finance_buddie/Model/FinancialChatRequest.dart';
import 'package:finance_buddie/Model/FinancialChatResponse.dart';
import 'package:finance_buddie/Model/RawTextAnalysisRequest.dart';
import 'package:finance_buddie/Model/RegisterRequest.dart';
import 'package:finance_buddie/Model/TextToSpeechResponse.dart';
import 'package:finance_buddie/services/BuddieService.dart';

class BuddieProvider with ChangeNotifier {
  final BuddieService _service;

  // Estados
  FinancialAnalysisResponse? _financialAnalysis;
  FinancialChatResponse? _financialChat;
  TextToSpeechResponse? _textToSpeech;
  bool _isLoading = false;
  String? _error;
  StreamController<String> _audioStream = StreamController<String>.broadcast();

  BuddieProvider(this._service);

  // Getters
  FinancialAnalysisResponse? get financialAnalysis => _financialAnalysis;
  FinancialChatResponse? get financialChat => _financialChat;
  TextToSpeechResponse? get textToSpeech => _textToSpeech;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Stream<String> get audioStream => _audioStream.stream;

  // Método genérico para manejar operaciones
  Future<T> _handleOperation<T>(Future<T> operation()) async {
    try {
      _setLoading(true);
      _error = null;
      notifyListeners();

      final result = await operation();
      return result;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error en BuddieProvider: $_error');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Operaciones principales
  Future<void> registerUser(String email) async {
    await _handleOperation(() async {
      final response = await _service.registerUser(
        RegisterRequest(email: email),
      );
      return response;
    });
  }

  Future<void> analyzeFinances(FinancialAnalysisRequest request) async {
    await _handleOperation(() async {
      _financialAnalysis = await _service.analyzeFinances(request);
      notifyListeners();
      return _financialAnalysis!;
    });
  }

  Future<void> analyzeRawText(RawTextAnalysisRequest request) async {
    await _handleOperation(() async {
      _financialAnalysis = await _service.analyzeRawText(request);
      notifyListeners();
      return _financialAnalysis!;
    });
  }

  Future<void> initiateFinancialChat(String message, String tone) async {
    await _handleOperation(() async {
      _financialChat = await _service.financialChat(
        FinancialChatRequest(
          message: message,
          tone: tone,
          chatHistory: _financialChat?.chatHistory ?? [],
        ),
      );
      notifyListeners();
      return _financialChat!;
    });
  }

  Future<void> initiateTextToSpeech(String text, String tone) async {
    await _handleOperation(() async {
      _textToSpeech = await _service.textToSpeech(
        TextToSpeechRequest(text: text, tone: tone),
      );

      if (_textToSpeech?.audioInfo.audioUrl != null) {
        _audioStream.add(_textToSpeech!.audioInfo.audioUrl);
      }

      notifyListeners();
      return _textToSpeech!;
    });
  }

  Future<void> analyzeAudioTransactions(
    String filePath, {
    String tone = 'professional',
    bool generateAudio = true,
  }) async {
    await _handleOperation(() async {
      _financialAnalysis = await _service.analyzeAudioTransactions(
        filePath,
        tone,
        generateAudio,
      );
      notifyListeners();
      return _financialAnalysis!;
    });
  }

  Future<void> voiceChat(
    String filePath, {
    String tone = 'professional',
    bool generateAudioResponse = true,
    List<Map<String, dynamic>>? chatHistory,
  }) async {
    await _handleOperation(() async {
      _financialChat = await _service.voiceChat(
        filePath,
        tone,
        generateAudioResponse,
        chatHistory,
      );
      notifyListeners();
      return _financialChat!;
    });
  }

  @override
  void dispose() {
    _audioStream.close();
    _service.dispose();
    super.dispose();
  }
}
