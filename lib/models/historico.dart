class Historico {
  final int? id;

  final int dataOp;

  final String tipoOp;

  final String moeda;

  final String sigla;

  final double valor;

  final double qtd;

  Historico(
      {this.id,
      required this.dataOp,
      required this.tipoOp,
      required this.moeda,
      required this.sigla,
      required this.valor,
      required this.qtd});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "data_operacao": dataOp,
      "tipo_operacao": tipoOp,
      "moeda": moeda,
      "sigla": sigla,
      "valor": valor,
      "qtd": qtd,
    };
  }

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
        id: json['id'],
        dataOp: json['dataOp'],
        tipoOp: json['tipoOp'],
        moeda: json['moeda'],
        sigla: json['sigla'],
        valor: (json['valor'] == null)
            ? 0.0
            : double.parse(json['valor'].toString()),
        qtd:
            (json['qtd'] == null)
            ? 0.0
            : double.parse(json['qtd'].toString()));
  }
}
