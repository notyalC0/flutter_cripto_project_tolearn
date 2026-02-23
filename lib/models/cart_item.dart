import 'moeda.dart';

class CartItem {
  final Moeda moeda;
  late final double valorReais;

  CartItem({required this.moeda, required this.valorReais});
  double get quantidadeMoeda => valorReais <= 0 ? 0 : valorReais / moeda.valor;
}
