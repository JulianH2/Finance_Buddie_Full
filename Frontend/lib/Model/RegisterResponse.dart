// Modelo para la respuesta del endpoint de registro
class RegisterResponse {
  final String status;
  final String token;
  final String expiresIn;
  final String userEmail;

  RegisterResponse({
    required this.status,
    required this.token,
    required this.expiresIn,
    required this.userEmail,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'],
      token: json['token'],
      expiresIn: json['expires_in'],
      userEmail: json['user_email'],
    );
  }
}

// Modelo para las transacciones en el body de /financial-analysis
class Transaction {
  final String description;
  final double amount;
  final String currency;

  Transaction({
    required this.description,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {'description': description, 'amount': amount, 'currency': currency};
  }
}
