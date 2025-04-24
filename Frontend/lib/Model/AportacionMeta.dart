class AportacionMeta {
  final int? idAportacion;
  final int idMeta;
  final double monto;
  final DateTime fechaAportacion;

  AportacionMeta({
    this.idAportacion,
    required this.idMeta,
    required this.monto,
    DateTime? fechaAportacion,
  }) : fechaAportacion = fechaAportacion ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idAportacion': idAportacion,
      'idMeta': idMeta,
      'monto': monto,
      'fechaAportacion': fechaAportacion.toIso8601String(),
    };
  }

  factory AportacionMeta.fromMap(Map<String, dynamic> map) {
    return AportacionMeta(
      idAportacion: map['idAportacion'],
      idMeta: map['idMeta'],
      monto: map['monto'],
      fechaAportacion: DateTime.parse(map['fechaAportacion']),
    );
  }
}