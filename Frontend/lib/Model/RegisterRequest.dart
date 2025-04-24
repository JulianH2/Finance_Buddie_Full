class RegisterRequest {
  final String email;

  RegisterRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
