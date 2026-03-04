class Moeda {
  String icone;
  String nome;
  String sigla;
  double valor;

  Moeda({
    required this.icone,
    required this.nome,
    required this.sigla,
    required this.valor,
  });

  factory Moeda.fromJson(Map<String, dynamic> json) {
    return Moeda(
      icone: json['icone'],
      nome: json['nome'],
      sigla: json['sigla'],
      valor: (json['valor'] as num).toDouble(),
    );
  }
}
