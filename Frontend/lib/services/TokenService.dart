import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static const String _keyToken = 'token';
  static const String _keyTokenFecha = 'token_fecha';
  static const Duration _duracionToken = Duration(days: 30);

  final String apiUrl = 'https://finance-buddie.up.railway.app/register';

  Future<String> obtenerTokenDesdeApi(String email) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status'] == 'success') {
        return decodedResponse['token'];
      } else {
        throw Exception('Error al obtener el token: ${decodedResponse['status']}');
      }
    } else {
      throw Exception('Error al realizar la solicitud: ${response.statusCode}');
    }
  }

  Future<void> guardarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyTokenFecha, DateTime.now().toIso8601String());
  }

  Future<String?> obtenerToken(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final fechaStr = prefs.getString(_keyTokenFecha);

    if (token != null && fechaStr != null) {
      final fechaCreacion = DateTime.tryParse(fechaStr);
      if (fechaCreacion != null &&
          DateTime.now().difference(fechaCreacion) <= _duracionToken) {
        return token; 
      }
    }

    final nuevoToken = await obtenerTokenDesdeApi(email);
    await guardarToken(nuevoToken);
    return nuevoToken;
  }

  Future<void> eliminarToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyTokenFecha);
  }
}