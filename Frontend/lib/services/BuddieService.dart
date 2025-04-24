import 'dart:convert';
import 'package:finance_buddie/Model/FinancialAnalysisRequest.dart';
import 'package:finance_buddie/Model/FinancialAnalysisResponse.dart';
import 'package:finance_buddie/Model/FinancialChatRequest.dart';
import 'package:finance_buddie/Model/FinancialChatResponse.dart';
import 'package:finance_buddie/Model/RawTextAnalysisRequest.dart';
import 'package:finance_buddie/Model/RegisterRequest.dart';
import 'package:finance_buddie/Model/RegisterResponse.dart';
import 'package:finance_buddie/Model/TextToSpeechRequest.dart';
import 'package:finance_buddie/Model/TextToSpeechResponse.dart';
import 'package:http/http.dart' as http;
import 'TokenService.dart';

class BuddieService {
  final http.Client _client;
  final TokenService _tokenService;
  final String baseUrl;
  final String email;

  BuddieService({
    required this.email,
    http.Client? client,
    TokenService? tokenService,
    this.baseUrl = 'https://finance-buddie.up.railway.app',
  }) : _client = client ?? http.Client(),
       _tokenService = tokenService ?? TokenService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenService.obtenerToken(email);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }

  Future<FinancialAnalysisResponse> analyzeFinances(
    FinancialAnalysisRequest request,
  ) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$baseUrl/financial-analysis'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FinancialAnalysisResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Financial analysis failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<FinancialAnalysisResponse> analyzeRawText(
    RawTextAnalysisRequest request,
  ) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$baseUrl/analyze-raw-text'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FinancialAnalysisResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Raw text analysis failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<TextToSpeechResponse> textToSpeech(TextToSpeechRequest request) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$baseUrl/text-to-speech'), // Nota: Corregí "speech" en la URL
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return TextToSpeechResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Text to speech failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<FinancialChatResponse> financialChat(
    FinancialChatRequest request,
  ) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$baseUrl/financial-chat'),
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return FinancialChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Financial chat failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<FinancialAnalysisResponse> analyzeAudioTransactions(
    String filePath,
    String tone,
    bool generateAudio,
  ) async {
    final token = await _tokenService.obtenerToken(email);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze-audio-transactions'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['tone'] = tone;
    request.fields['generate_audio'] = generateAudio.toString();
    request.files.add(
      await http.MultipartFile.fromPath('audio_file', filePath),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return FinancialAnalysisResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Audio analysis failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  Future<FinancialChatResponse> voiceChat(
    String filePath,
    String tone,
    bool generateAudioResponse,
    List<Map<String, dynamic>>? chatHistory,
  ) async {
    final token = await _tokenService.obtenerToken(email);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/voice-chat'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['tone'] = tone;
    request.fields['generate_audio_response'] =
        generateAudioResponse.toString();
    if (chatHistory != null) {
      request.fields['chat_history'] = jsonEncode(chatHistory);
    }
    request.files.add(
      await http.MultipartFile.fromPath('audio_file', filePath),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return FinancialChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Voice chat failed: ${response.statusCode}, ${response.body}',
      );
    }
  }

  // Cierra el cliente HTTP cuando ya no sea necesario
  void dispose() {
    _client.close();
  }
}
