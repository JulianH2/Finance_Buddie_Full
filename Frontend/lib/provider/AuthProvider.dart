import 'package:flutter/material.dart';
import '../services/AuthService.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('AuthProvider: Login attempt with email: $email');
      final response = await _authService.login(email, password);
      print('AuthProvider: Login successful');
      notifyListeners();
      return response;
    } catch (e) {
      print('AuthProvider: Login failed with error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String nombre,
    String correo,
    String hashContrasenia,
    String telefono,
  ) async {
    try {
      print('AuthProvider: Register attempt with email: $correo');
      final response = await _authService.register(
        nombre,
        correo,
        hashContrasenia,
        telefono,
      );
      print('AuthProvider: Register successful');
      notifyListeners();
      return response;
    } catch (e) {
      print('AuthProvider: Register failed with error: $e');
      rethrow;
    }
  }
}