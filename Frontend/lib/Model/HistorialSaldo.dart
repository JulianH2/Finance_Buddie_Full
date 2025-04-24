class HistorialSaldo {
  final int? idHistorial;
  final double saldo;
  final DateTime fechaRegistro;

  HistorialSaldo({
    this.idHistorial,
    required this.saldo,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idHistorial': idHistorial,
      'saldo': saldo,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory HistorialSaldo.fromMap(Map<String, dynamic> map) {
    return HistorialSaldo(
      idHistorial: map['idHistorial'],
      saldo: map['saldo'],
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }
}