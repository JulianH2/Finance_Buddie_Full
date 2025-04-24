class LoginRequest {
  String correo;
  String contrasenia;

  LoginRequest({required this.correo, required this.contrasenia});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      LoginRequest(correo: json['correo'], contrasenia: json['contrasenia']);

  Map<String, dynamic> toJson() => {
    'correo': correo,
    'contrasenia': contrasenia,
  };
}
