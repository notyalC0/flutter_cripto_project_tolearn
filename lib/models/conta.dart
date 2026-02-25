class Conta {
  final int id;
  final double saldo;

  Conta({required this.id, required this.saldo});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "saldo": saldo,
    };
  }

  factory Conta.fromJson(Map<String, dynamic> json) {
    return Conta(id: json['id'], saldo: json['saldo']);
  }
}
