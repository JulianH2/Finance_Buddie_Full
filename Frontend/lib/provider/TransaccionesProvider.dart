import 'package:flutter/material.dart';
import '../services/TransaccionesService.dart';

class TransaccionesProvider with ChangeNotifier {
  final TransaccionesService _transaccionesService;
  List<dynamic> _transacciones = [];
  bool _isLoading = false;
  String? _errorMessage;

  TransaccionesProvider() : _transaccionesService = TransaccionesService();

  List<dynamic> get transacciones => _transacciones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarTransacciones(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transacciones = await _transaccionesService.obtenerTransacciones(
        idUsuario,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _transacciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> crearTransaccion(
    Map<String, dynamic> transaccion,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.crearTransaccion(
        transaccion,
      );
      await cargarTransacciones(transaccion['idUsuario']);
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> actualizarTransaccion(
    Map<String, dynamic> transaccion,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.actualizarTransaccion(
        transaccion,
      );
      await cargarTransacciones(transaccion['idUsuario']);
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarTransaccion(int idTransaccion, int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transaccionesService.eliminarTransaccion(idTransaccion);
      await cargarTransacciones(idUsuario);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> obtenerTotalesPorTipo(int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.obtenerTotalesPorTipo(
        idUsuario,
      );
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> obtenerPorCategoria(
    int idUsuario,
    String categoria,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.obtenerPorCategoria(
        idUsuario,
        categoria,
      );
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> obtenerGastosPorMes(int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.obtenerGastosPorMes(
        idUsuario,
      );
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> obtenerIngresosPorCategoria(
    int idUsuario,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.obtenerIngresosPorCategoria(
        idUsuario,
      );
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> obtenerGastosPorCategoria(int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      final resultado = await _transaccionesService.obtenerGastosPorCategoria(
        idUsuario,
      );
      return resultado;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarErrores() {
    _errorMessage = null;
    notifyListeners();
  }

  obtenerTransaccionesRecientes() {}
}
