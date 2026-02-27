class Login {
  final String email;
  final String senha;

  Login({
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "senha": senha,
    };
  }
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}
