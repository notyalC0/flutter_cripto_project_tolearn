class Transacao {
  final int dataOperacao;
  final String tipo;
  final String moeda;
  final String sigla;
  final double valor;
  final double quantidade;

  Transacao(
      {required this.dataOperacao,
      required this.tipo,
      required this.moeda,
      required this.sigla,
      required this.valor,
      required this.quantidade});
}
