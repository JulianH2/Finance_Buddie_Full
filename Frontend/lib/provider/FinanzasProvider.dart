import 'package:flutter/material.dart';
import 'package:finance_buddie/services/finanzas_service.dart';
import '../Model/Transaccion.dart';
import '../Model/MetaAhorro.dart';
import '../Model/AportacionMeta.dart';
import '../Model/HistorialSaldo.dart';

class FinanzasProvider with ChangeNotifier {
  final FinanzasService _finanzasService;

  List<Transaccion> _transacciones = [];
  List<MetaAhorro> _metas = [];
  List<AportacionMeta> _aportaciones = [];
  List<HistorialSaldo> _historialSaldo = [];
  double _saldoActual = 0.0;
  double _totalIngresos = 0.0;
  double _totalGastos = 0.0;

  // Constructor modificado
  FinanzasProvider() : _finanzasService = FinanzasService() {
    cargarDatosIniciales();
  }

  // Getters
  List<Transaccion> get transacciones => _transacciones;
  List<MetaAhorro> get metas => _metas;
  List<AportacionMeta> get aportaciones => _aportaciones;
  List<HistorialSaldo> get historialSaldo => _historialSaldo;
  double get saldoActual => _saldoActual;
  double get totalIngresos => _totalIngresos;
  double get totalGastos => _totalGastos;

  /// Carga inicial de datos para transacciones, metas, aportaciones y saldo
  Future<void> cargarDatosIniciales() async {
    _transacciones = await _finanzasService.obtenerTransacciones();
    _metas = await _finanzasService.obtenerMetasAhorro();
    _aportaciones.clear();
    for (var meta in _metas) {
      final lista = await _finanzasService.obtenerAportacionesPorMeta(
        meta.idMeta!,
      );
      _aportaciones.addAll(lista);
    }
    _historialSaldo = await _finanzasService.obtenerHistorialSaldoCompleto();
    _saldoActual = await _finanzasService.obtenerUltimoSaldo();
    _totalIngresos = await _finanzasService.obtenerTotalIngresos();
    _totalGastos = await _finanzasService.obtenerTotalGastos();
    notifyListeners();
  }

  /// Transacciones
  Future<void> agregarTransaccion(Transaccion transaccion) async {
    await _finanzasService.crearTransaccion(transaccion);
    await cargarDatosIniciales();
  }

  Future<void> eliminarTransaccion(int idTransaccion) async {
    await _finanzasService.eliminarTransaccion(idTransaccion);
    await cargarDatosIniciales();
  }

  Future<List<Transaccion>> obtenerTransaccionesRecientes() async {
    return await _finanzasService.obtenerTransaccionesRecientes();
  }

  /// Metas de ahorro
  Future<void> crearMetaAhorro(MetaAhorro meta) async {
    await _finanzasService.crearMetaAhorro(meta);
    await cargarDatosIniciales();
  }

  Future<void> actualizarMetaAhorro(MetaAhorro meta) async {
    await _finanzasService.actualizarMetaAhorro(meta);
    await cargarDatosIniciales();
  }

  /// Aportaciones a metas
  Future<void> crearAportacion(AportacionMeta aportacion) async {
    await _finanzasService.crearAportacion(aportacion);
    await cargarDatosIniciales();
  }

  Future<List<AportacionMeta>> obtenerAportacionesPorMeta(int idMeta) async {
    return await _finanzasService.obtenerAportacionesPorMeta(idMeta);
  }

  /// Historial y saldo
  Future<void> registrarSaldo(double saldo) async {
    await _finanzasService.registrarSaldo(saldo);
    await cargarDatosIniciales();
  }

  Future<double> obtenerUltimoSaldo() async {
    return await _finanzasService.obtenerUltimoSaldo();
  }

  /// Estadísticas
  Future<double> obtenerBalance() async {
    return await _finanzasService.obtenerBalanceTotal();
  }

  Future<double> obtenerTotalIngresos() async {
    return await _finanzasService.obtenerTotalIngresos();
  }

  Future<double> obtenerTotalGastos() async {
    return await _finanzasService.obtenerTotalGastos();
  }

  Future<double> obtenerPorcentajeCrecimiento() async {
    return await _finanzasService.obtenerPorcentajeCrecimiento();
  }

  Future<Map<int, double>> obtenerProgresoMetas() async {
    return await _finanzasService.obtenerProgresoMetas();
  }

  Future<List<HistorialSaldo>> obtenerHistorialSaldoCompleto() async {
    return await _finanzasService.obtenerHistorialSaldoCompleto();
  }

  Future<Map<String, double>> obtenerGastosPorCategoria() async {
    return await _finanzasService.obtenerTransaccionesPorCategoria();
  }

  /// Transacciones completas
  Future<List<Transaccion>> obtenerTransacciones() async {
    return await _finanzasService.obtenerTransacciones();
  }

  /// Operaciones compuestas
  Future<void> ejecutarSimulacionCompleta() async {
    await _finanzasService.ejecutarSimulacionCompleta();
    await cargarDatosIniciales();
  }

  Future<void> aportarAMetaConSeguridad({
    required int idMeta,
    required double monto,
    required String categoriaGasto,
  }) async {
    await _finanzasService.aportarAMetaConSeguridad(
      idMeta: idMeta,
      monto: monto,
      categoriaGasto: categoriaGasto,
    );
    await cargarDatosIniciales();
  }

  //Finansas Graficas
  Future<Map<String, double>> obtenerIngresosPorMes() async {
    return await _finanzasService.obtenerIngresosPorMes();
  }

  Future<Map<String, double>> obtenerGastosPorMes() async {
    return await _finanzasService.obtenerGastosPorMes();
  }

  Future<Map<String, double>> obtenerIngresosPorCategoria() async {
    return await _finanzasService.obtenerIngresosPorCategoria();
  }
}