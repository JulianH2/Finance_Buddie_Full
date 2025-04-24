class Token {
  int idToken;
  int idUsuario;
  String token;
  DateTime fecha;

  Token({
    required this.idToken,
    required this.idUsuario,
    required this.token,
    required this.fecha,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    idToken: json['idToken'],
    idUsuario: json['idUsuario'],
    token: json['token'],
    fecha: DateTime.parse(json['fecha']),
  );

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
    'idUsuario': idUsuario,
    'token': token,
    'fecha': fecha.toIso8601String(),
  };
}
