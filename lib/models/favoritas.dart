class Favoritas {
  String? icone;
  String? nome;
  String sigla;
  double? valor;

  Favoritas({
    this.icone,
    this.nome,
    required this.sigla,
    this.valor,
  });

  Map<String, dynamic> toJson() {
    return {
      "icone": "icone",
      "nome": "nome",
      "sigla": "sigla",
      "valor": "valor",
    };
  }

  factory Favoritas.fromJson(Map<String, dynamic> json) {
    return Favoritas(
      icone: json['icone'],
      nome: json['nome'],
      sigla: json['sigla'],
      valor: double.tryParse(json['valor'].toString()) ?? 0.0 ,
    );
  }
}
