import 'package:finance_buddie/Model/AportacionMeta.dart';
import 'package:finance_buddie/Model/HistorialSaldo.dart';
import 'package:finance_buddie/Model/MetaAhorro.dart';
import 'package:finance_buddie/Model/Transaccion.dart';
import 'package:finance_buddie/database/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class FinanzasService {
  //  final DatabaseHelper _dbHelper = DatabaseHelper();

  // ------------------------- TRANSACCIONES -------------------------
  Future<int> crearTransaccion(Transaccion transaccion) async {
    final db = await DatabaseHelper.database;
    return await db.insert(
      'Transacciones',
      transaccion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transaccion>> obtenerTransacciones() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Transacciones');
    return List.generate(maps.length, (i) => Transaccion.fromMap(maps[i]));
  }

  Future<int> eliminarTransaccion(int idTransaccion) async {
    final db = await DatabaseHelper.database;
    return await db.delete(
      'Transacciones',
      where: 'idTransaccion = ?',
      whereArgs: [idTransaccion],
    );
  }

  // ------------------------- METAS AHORRO -------------------------
  Future<int> crearMetaAhorro(MetaAhorro meta) async {
    final db = await DatabaseHelper.database;
    return await db.insert(
      'MetasAhorro',
      meta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MetaAhorro>> obtenerMetasAhorro() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('MetasAhorro');
    return List.generate(maps.length, (i) => MetaAhorro.fromMap(maps[i]));
  }

  Future<int> actualizarMetaAhorro(MetaAhorro meta) async {
    final db = await DatabaseHelper.database;
    return await db.update(
      'MetasAhorro',
      meta.toMap(),
      where: 'idMeta = ?',
      whereArgs: [meta.idMeta],
    );
  }

  // -------------------- APORTACIONES A METAS ---------------------
  Future<int> crearAportacion(AportacionMeta aportacion) async {
    final db = await DatabaseHelper.database;
    return await db.insert(
      'AportacionesMeta',
      aportacion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AportacionMeta>> obtenerAportacionesPorMeta(int idMeta) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AportacionesMeta',
      where: 'idMeta = ?',
      whereArgs: [idMeta],
    );
    return List.generate(maps.length, (i) => AportacionMeta.fromMap(maps[i]));
  }

  // -------------------- HISTORIAL DE SALDO ---------------------
  Future<int> registrarSaldo(double saldo) async {
    final db = await DatabaseHelper.database;
    final nuevoRegistro = HistorialSaldo(saldo: saldo);
    return await db.insert(
      'HistorialSaldo',
      nuevoRegistro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> obtenerUltimoSaldo() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'HistorialSaldo',
      orderBy: 'fechaRegistro DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first['saldo'] as double : 0.0;
  }

  // ==================== MÉTODOS PARA MINICIOSCREEN ====================

  /// Obtiene el balance total (ingresos - gastos)
  Future<double> obtenerBalanceTotal() async {
    final db = await DatabaseHelper.database;

    final ingresos = await db.rawQuery(
      "SELECT SUM(monto) as total FROM Transacciones WHERE tipo = 'Ingreso'",
    );

    final gastos = await db.rawQuery(
      "SELECT SUM(monto) as total FROM Transacciones WHERE tipo = 'Gasto'",
    );

    final totalIngresos = ingresos.first['total'] as double? ?? 0.0;
    final totalGastos = gastos.first['total'] as double? ?? 0.0;

    return totalIngresos - totalGastos;
  }

  /// Obtiene el total de ingresos
  Future<double> obtenerTotalIngresos() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      "SELECT SUM(monto) as total FROM Transacciones WHERE tipo = 'Ingreso'",
    );
    return result.first['total'] as double? ?? 0.0;
  }

  /// Obtiene el total de gastos
  Future<double> obtenerTotalGastos() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      "SELECT SUM(monto) as total FROM Transacciones WHERE tipo = 'Gasto'",
    );
    return result.first['total'] as double? ?? 0.0;
  }

  /// Obtiene las transacciones recientes (últimas 5 ordenadas por fecha)
  Future<List<Transaccion>> obtenerTransaccionesRecientes() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Transacciones',
      orderBy: 'fechaOperacion DESC',
      limit: 5,
    );
    return List.generate(maps.length, (i) => Transaccion.fromMap(maps[i]));
  }

  /// Obtiene el porcentaje de crecimiento (puedes personalizar este cálculo)
  Future<double> obtenerPorcentajeCrecimiento() async {
    // Implementación básica - puedes ajustar según tu lógica de negocio
    final balanceActual = await obtenerBalanceTotal();
    final balanceAnterior =
        balanceActual * 0.88; // Simula un 12% de crecimiento
    if (balanceAnterior == 0) return 0.0;
    return ((balanceActual - balanceAnterior) / balanceAnterior) * 100;
  }

  // ===================== OPERACIONES COMPUESTAS =====================

  /// Simula el flujo completo de:
  /// 1. Registrar transacciones (ingreso + gasto)
  /// 2. Calcular y guardar saldo
  /// 3. Crear meta de ahorro
  /// 4. Aportar a la meta
  Future<void> ejecutarSimulacionCompleta() async {
    final db = await DatabaseHelper.database;

    await db.transaction((txn) async {
      // 1. Registrar transacciones
      final ingreso = Transaccion(
        monto: 5000.00,
        tipo: 'Ingreso',
        fechaOperacion: DateTime.now(),
        categoria: 'Salario',
        descripcion: 'Pago mensual',
      );
      await txn.insert('Transacciones', ingreso.toMap());

      final gasto = Transaccion(
        monto: 1500.00,
        tipo: 'Gasto',
        fechaOperacion: DateTime.now(),
        categoria: 'Compras',
        descripcion: 'Supermercado y hogar',
      );
      await txn.insert('Transacciones', gasto.toMap());

      // 2. Calcular y guardar saldo (5000 - 1500 = 3500)
      await txn.insert('HistorialSaldo', HistorialSaldo(saldo: 3500.0).toMap());

      // 3. Crear meta de ahorro
      final meta = MetaAhorro(
        nombreMeta: 'Nuevo teléfono',
        descripcion: 'Ahorro para comprar un nuevo teléfono',
        montoObjetivo: 2000.00,
        fechaFin: DateTime(2025, 12, 31),
      );
      final metaId = await txn.insert('MetasAhorro', meta.toMap());

      // 4. Aportar 1000 a la meta
      await txn.insert(
        'AportacionesMeta',
        AportacionMeta(idMeta: metaId, monto: 1000.0).toMap(),
      );

      // Actualizar montoActual en la meta
      await txn.update(
        'MetasAhorro',
        {'montoActual': 1000.0},
        where: 'idMeta = ?',
        whereArgs: [metaId],
      );
    });
  }

  /// Operación segura para aportar a una meta:
  /// 1. Verifica que haya saldo suficiente
  /// 2. Actualiza el saldo
  /// 3. Registra la aportación
  /// 4. Actualiza la meta
  Future<void> aportarAMetaConSeguridad({
    required int idMeta,
    required double monto,
    required String categoriaGasto,
  }) async {
    final db = await DatabaseHelper.database;

    await db.transaction((txn) async {
      // 1. Verificar saldo
      final ultimoSaldo = await obtenerUltimoSaldo();
      if (ultimoSaldo < monto) {
        throw Exception('Saldo insuficiente');
      }

      // 2. Registrar gasto (como transacción)
      await txn.insert(
        'Transacciones',
        Transaccion(
          monto: monto,
          tipo: 'Gasto',
          fechaOperacion: DateTime.now(),
          categoria: categoriaGasto,
          descripcion: 'Aportación a meta',
          idMeta: idMeta,
        ).toMap(),
      );

      // 3. Actualizar saldo
      await txn.insert(
        'HistorialSaldo',
        HistorialSaldo(saldo: ultimoSaldo - monto).toMap(),
      );

      // 4. Registrar aportación
      await txn.insert(
        'AportacionesMeta',
        AportacionMeta(idMeta: idMeta, monto: monto).toMap(),
      );

      // 5. Actualizar meta
      await txn.rawUpdate(
        'UPDATE MetasAhorro SET montoActual = montoActual + ? WHERE idMeta = ?',
        [monto, idMeta],
      );
    });
  }

  // ==================== MÉTODOS ADICIONALES ÚTILES ====================

  /// Obtiene el progreso de todas las metas (0.0 a 1.0)
  Future<Map<int, double>> obtenerProgresoMetas() async {
    final metas = await obtenerMetasAhorro();
    final progreso = <int, double>{};

    for (final meta in metas) {
      progreso[meta.idMeta!] = meta.montoActual / meta.montoObjetivo;
    }

    return progreso;
  }

  /// Obtiene el historial de saldo completo
  Future<List<HistorialSaldo>> obtenerHistorialSaldoCompleto() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'HistorialSaldo',
      orderBy: 'fechaRegistro DESC',
    );
    return List.generate(maps.length, (i) => HistorialSaldo.fromMap(maps[i]));
  }

  /// Obtiene transacciones por categoría
  Future<Map<String, double>> obtenerTransaccionesPorCategoria() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      "SELECT categoria, SUM(monto) as total FROM Transacciones WHERE tipo = 'Gasto' GROUP BY categoria",
    );

    final categorias = <String, double>{};
    for (final row in result) {
      final categoria = row['categoria'] as String;
      final total = (row['total'] as num).toDouble(); // más seguro
      categorias[categoria] = total;
    }

    return categorias;
  }

  /// Obtiene ingresos agrupados por mes
  Future<Map<String, double>> obtenerIngresosPorMes() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
    SELECT strftime('%Y-%m', fechaOperacion) as mes, 
           SUM(monto) as total 
    FROM Transacciones 
    WHERE tipo = 'Ingreso'
    GROUP BY mes
    ORDER BY mes
  ''');

    return Map.fromEntries(
      result.map((e) => MapEntry(e['mes'] as String, e['total'] as double)),
    );
  }

  /// Obtiene gastos agrupados por mes
  Future<Map<String, double>> obtenerGastosPorMes() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery('''
    SELECT strftime('%Y-%m', fechaOperacion) as mes, 
           SUM(monto) as total 
    FROM Transacciones 
    WHERE tipo = 'Gasto'
    GROUP BY mes
    ORDER BY mes
  ''');

    return Map.fromEntries(
      result.map((e) => MapEntry(e['mes'] as String, e['total'] as double)),
    );
  }

  /// Obtiene ingresos agrupados por categoría
  Future<Map<String, double>> obtenerIngresosPorCategoria() async {
    final transacciones = await obtenerTransacciones();
    final ingresos = transacciones.where((t) => t.tipo == 'ingreso');
    final Map<String, double> mapa = {};
    for (var t in ingresos) {
      mapa[t.categoria] = (mapa[t.categoria] ?? 0) + t.monto;
    }
    return mapa;
  }

  Future<Map<String, double>> obtenerGastosPorCategoria() async {
    final transacciones = await obtenerTransacciones();
    final egresos = transacciones.where((t) => t.tipo == 'egreso');
    final Map<String, double> mapa = {};
    for (var t in egresos) {
      mapa[t.categoria] = (mapa[t.categoria] ?? 0) + t.monto;
    }
    return mapa;
  }
}
