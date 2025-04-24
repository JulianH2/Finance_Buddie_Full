import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://FinanzasBuddie.bsite.net/api/usuario';

  Future<Map<String, dynamic>> login(String correo, String contrasenia) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'Correo': correo, 'Contraseña': contrasenia}),
      );

      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 && decodedResponse['success'] == true) {
        return decodedResponse['data'];
      } else {
        final mensaje = decodedResponse['message'] ?? 'Error desconocido';

        // Si existen errores de validación más específicos
        final errores = decodedResponse['data'];
        if (errores != null && errores is Map) {
          final erroresTexto = errores.entries
              .map((entry) {
                final field = entry.key;
                final fieldErrors =
                    entry.value['_errors'] as List<dynamic>? ?? [];
                return '$field: ${fieldErrors.map((e) => e['<ErrorMessage>k__BackingField']).join(", ")}';
              })
              .join(' | ');

          throw Exception('Error al iniciar sesión: $mensaje - $erroresTexto');
        }

        throw Exception('Error al iniciar sesión: $mensaje');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register(
    String nombre,
    String correo,
    String hashContrasenia,
    String telefono,
  ) async {
    final url = Uri.parse('$_baseUrl/registro');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombre,
        'correo': correo,
        'hashContraseña': hashContrasenia,
        'telefono': telefono,
        'fechaCreacion':
            DateTime.now().toIso8601String(), // You might need to adjust this
        'estaActivo': true, // You might need to adjust this
      }),
    );

    final decodedResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return decodedResponse;
    } else {
      throw Exception(
        'Error al registrar: ${decodedResponse['message'] ?? 'Error desconocido'}',
      );
    }
  }
}
