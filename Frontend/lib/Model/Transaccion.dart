class Transaccion {
  final int? idTransaccion;
  final double monto;
  final String tipo; // 'Ingreso' o 'Gasto'
  final DateTime fechaOperacion;
  final String categoria;
  final String? descripcion;
  final DateTime fechaCreacion;
  final int? idMeta;

  Transaccion({
    this.idTransaccion,
    required this.monto,
    required this.tipo,
    required this.fechaOperacion,
    required this.categoria,
    this.descripcion,
    DateTime? fechaCreacion,
    this.idMeta,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idTransaccion': idTransaccion,
      'monto': monto,
      'tipo': tipo,
      'fechaOperacion': fechaOperacion.toIso8601String(),
      'categoria': categoria,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'idMeta': idMeta,
    };
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      idTransaccion: map['idTransaccion'],
      monto: map['monto'],
      tipo: map['tipo'],
      fechaOperacion: DateTime.parse(map['fechaOperacion']),
      categoria: map['categoria'],
      descripcion: map['descripcion'],
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
      idMeta: map['idMeta'],
    );
  }
}
