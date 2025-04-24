class MetaAhorro {
  final int? idMeta;
  final String nombreMeta;
  final String? descripcion;
  final double montoObjetivo;
  final double montoActual;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool estaCompletada;
  final DateTime fechaCreacion;

  MetaAhorro({
    this.idMeta,
    required this.nombreMeta,
    this.descripcion,
    required this.montoObjetivo,
    this.montoActual = 0.0,
    DateTime? fechaInicio,
    required this.fechaFin,
    this.estaCompletada = false,
    DateTime? fechaCreacion,
  }) : fechaInicio = fechaInicio ?? DateTime.now(),
       fechaCreacion = fechaCreacion ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idMeta': idMeta,
      'nombreMeta': nombreMeta,
      'descripcion': descripcion,
      'montoObjetivo': montoObjetivo,
      'montoActual': montoActual,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'estaCompletada': estaCompletada ? 1 : 0,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  factory MetaAhorro.fromMap(Map<String, dynamic> map) {
    return MetaAhorro(
      idMeta: map['idMeta'],
      nombreMeta: map['nombreMeta'],
      descripcion: map['descripcion'],
      montoObjetivo: map['montoObjetivo'],
      montoActual: map['montoActual'],
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      estaCompletada: map['estaCompletada'] == 1,
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
    );
  }
}
