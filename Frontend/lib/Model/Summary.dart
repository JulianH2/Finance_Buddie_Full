class Summary {
  final Map<String, String> ingresos;
  final Map<String, String> egresos;

  Summary({required this.ingresos, required this.egresos});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      ingresos: Map<String, String>.from(json['ingresos']),
      egresos: Map<String, String>.from(json['egresos']),
    );
  }
}
