import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constantes.dart'; // Ajusta según tu estructura de carpetas

class MetasAhorroService {
  final headers = {'Content-Type': 'application/json'};

  Future<bool> crearMeta(Map<String, dynamic> meta) async {
    final url = Uri.parse(Constantes.crearMeta);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(meta),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al crear meta');
      }
    } catch (e) {
      throw Exception('Error al crear meta: $e');
    }
  }

  Future<bool> actualizarMeta(Map<String, dynamic> meta) async {
    final url = Uri.parse(Constantes.actualizarMeta);

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(meta),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al actualizar meta');
      }
    } catch (e) {
      throw Exception('Error al actualizar meta: $e');
    }
  }

  Future<bool> eliminarMeta(int idMeta) async {
    final url = Uri.parse('${Constantes.eliminarMeta}/$idMeta');

    try {
      final response = await http.delete(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al eliminar meta');
      }
    } catch (e) {
      throw Exception('Error al eliminar meta: $e');
    }
  }

  Future<List<dynamic>> obtenerMetas(int idUsuario) async {
    final url = Uri.parse('${Constantes.obtenerMetas}/$idUsuario');

    try {
      final response = await http.get(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener metas');
      }
    } catch (e) {
      throw Exception('Error al obtener metas: $e');
    }
  }
}
