import 'package:flutter_app/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(
        icone: "images/bitcoin.png",
        nome: 'Bitcoin',
        sigla: 'BTC',
        valor: 340971.56),
    Moeda(
        icone: "images/cardano.png",
        nome: 'Cardano',
        sigla: 'ADA',
        valor: 1.50),
    Moeda(
        icone: "images/ethereum.png",
        nome: 'Ethereum',
        sigla: 'ETH',
        valor: 23000.00),
    Moeda(
        icone: "images/litecoin.png",
        nome: 'Litecoin',
        sigla: 'LTC',
        valor: 120.00),
    Moeda(
        icone: "images/usdcoin.png",
        nome: 'USD Coin',
        sigla: 'USDC',
        valor: 1.00),
    Moeda(icone: "images/xrp.png", nome: "Xrp", sigla: "XRP", valor: 1.25)
  ];


}
