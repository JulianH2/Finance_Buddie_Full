import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constantes.dart'; // Ajusta la ruta según tu estructura de carpetas

class TransaccionesService {
  final headers = {'Content-Type': 'application/json'};

  Future<Map<String, dynamic>> crearTransaccion(
    Map<String, dynamic> transaccion,
  ) async {
    final url = Uri.parse(Constantes.crearTransaccion);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(transaccion),
      );

      final decoded = json.decode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al crear la transacción');
      }
    } catch (e) {
      throw Exception('Error al crear la transacción: $e');
    }
  }

  Future<Map<String, dynamic>> actualizarTransaccion(
    Map<String, dynamic> transaccion,
  ) async {
    final url = Uri.parse(Constantes.actualizarTransaccion);

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(transaccion),
      );

      final decoded = json.decode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(
          decoded['message'] ?? 'Error al actualizar la transacción',
        );
      }
    } catch (e) {
      throw Exception('Error al actualizar la transacción: $e');
    }
  }

  Future<void> eliminarTransaccion(int idTransaccion) async {
    final url = Uri.parse('${Constantes.eliminarTransaccion}/$idTransaccion');

    try {
      final response = await http.delete(url, headers: headers);
      final decoded = json.decode(response.body);

      if (response.statusCode != 200 || decoded['success'] != true) {
        throw Exception(decoded['message'] ?? 'Error al eliminar transacción');
      }
    } catch (e) {
      throw Exception('Error al eliminar transacción: $e');
    }
  }

  Future<List<dynamic>> obtenerTransacciones(int idUsuario) async {
    final url = Uri.parse('${Constantes.obtenerTransacciones}/$idUsuario');

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener transacciones');
      }
    } catch (e) {
      throw Exception('Error al obtener transacciones: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerTotalesPorTipo(int idUsuario) async {
    final url = Uri.parse('${Constantes.totalesPorTipo}/$idUsuario');

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(
          decoded['message'] ?? 'Error al obtener totales por tipo',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener totales por tipo: $e');
    }
  }

  Future<List<dynamic>> obtenerPorCategoria(
    int idUsuario,
    String categoria,
  ) async {
    final url = Uri.parse(
      '${Constantes.transaccionesPorCategoria}/$idUsuario/$categoria',
    );

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(decoded['message'] ?? 'Error al obtener por categoría');
      }
    } catch (e) {
      throw Exception('Error al obtener por categoría: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerGastosPorMes(int idUsuario) async {
    final url = Uri.parse('${Constantes.gastosPorMes}/$idUsuario');

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(
          decoded['message'] ?? 'Error al obtener gastos por mes',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener gastos por mes: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerIngresosPorCategoria(
    int idUsuario,
  ) async {
    final url = Uri.parse('${Constantes.ingresosPorCategoria}/$idUsuario');

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(
          decoded['message'] ?? 'Error al obtener ingresos por categoría',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener ingresos por categoría: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerGastosPorCategoria(int idUsuario) async {
    final url = Uri.parse('${Constantes.gastosPorCategoria}/$idUsuario');

    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return decoded['data'];
      } else {
        throw Exception(
          decoded['message'] ?? 'Error al obtener gastos por categoría',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener gastos por categoría: $e');
    }
  }
}
