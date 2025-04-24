import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constantes.dart'; // Ajusta según tu estructura de carpetas

class AportacionesMetaService {
  final headers = {'Content-Type': 'application/json'};

  Future<bool> crearAportacion(Map<String, dynamic> aportacion) async {
    final url = Uri.parse(Constantes.crearAportacion);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(aportacion),
      );
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al crear aportación');
      }
    } catch (e) {
      throw Exception('Error al crear aportación: $e');
    }
  }

  Future<bool> actualizarAportacion(Map<String, dynamic> aportacion) async {
    final url = Uri.parse(Constantes.actualizarAportacion);

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(aportacion),
      );
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al actualizar aportación');
      }
    } catch (e) {
      throw Exception('Error al actualizar aportación: $e');
    }
  }

  Future<bool> eliminarAportacion(int idAportacion) async {
    final url = Uri.parse('${Constantes.eliminarAportacion}/$idAportacion');

    try {
      final response = await http.delete(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return true;
      } else {
        throw Exception(decoded['message'] ?? 'Error al eliminar aportación');
      }
    } catch (e) {
      throw Exception('Error al eliminar aportación: $e');
    }
  }

  Future<List<dynamic>> obtenerAportaciones(int idMeta) async {
    final url = Uri.parse('${Constantes.obtenerAportaciones}/$idMeta');

    try {
      final response = await http.get(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener aportaciones');
      }
    } catch (e) {
      throw Exception('Error al obtener aportaciones: $e');
    }
  }
}
