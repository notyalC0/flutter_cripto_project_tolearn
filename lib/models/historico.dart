class Historico {
  final int id;

  final int data_operacao;

  final String tipo_operacao;

  final String moeda;

  final String sigla;

  final double valor;

  final double quantidade;

  Historico(
      {required this.id,
      required this.data_operacao,
      required this.tipo_operacao,
      required this.moeda,
      required this.sigla,
      required this.valor,
      required this.quantidade});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "data_operacao": data_operacao,
      "tipo_operacao": tipo_operacao,
      "moeda": moeda,
      "sigla": sigla,
      "valor": valor,
      "quantidade": quantidade,
    };
  }

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
        id: json['id'],
        data_operacao: json['data_operacao'],
        tipo_operacao: json['tipo_operacao'],
        moeda: json['moeda'],
        sigla: json['sigla'],
        valor: json['valor'],
        quantidade: json['quantidade']);
  }
}
