class Carteira {
  final String sigla;
  final String moeda;
  final String quantidade;

  Carteira(
      {required this.sigla, required this.moeda, required this.quantidade});

  Map<String, dynamic> toJson() {
    return {
      "sigla": sigla,
      "moeda": moeda,
      "quantidade": quantidade,
    };
  }

  factory Carteira.fromJson(Map<String, dynamic> json) {
    return Carteira(
        sigla: json['sigla'],
        moeda: json['moeda'],
        quantidade: json['quantidade']);
  }
}
