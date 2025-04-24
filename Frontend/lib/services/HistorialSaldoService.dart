import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constantes.dart'; // Ajusta la ruta según tu estructura de carpetas

class HistorialSaldoService {
  final headers = {'Content-Type': 'application/json'};

  Future<List<dynamic>> obtenerHistorialSaldo(int idUsuario) async {
    final url = Uri.parse('${Constantes.obtenerHistorialSaldo}/$idUsuario');

    try {
      final response = await http.get(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener historial de saldo');
      }
    } catch (e) {
      throw Exception('Error al obtener historial de saldo: $e');
    }
  }

  Future<double> obtenerSaldoActual(int idUsuario) async {
    final url = Uri.parse('${Constantes.obtenerSaldoActual}/$idUsuario');

    try {
      final response = await http.get(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return (decoded['data'] as num).toDouble();
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener saldo actual');
      }
    } catch (e) {
      throw Exception('Error al obtener saldo actual: $e');
    }
  }
}
