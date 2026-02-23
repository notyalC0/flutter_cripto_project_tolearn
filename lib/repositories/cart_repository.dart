import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/moeda.dart';

class CartRepository extends ChangeNotifier {
  final List<CartItem> _items = [];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  double get totalReais => _items.fold(0.0, (s, i) => s + i.valorReais);

  CartItem? find(Moeda moeda) {
    try {
      return _items.firstWhere((i) => i.moeda.sigla == moeda.sigla);
    } catch (_) {
      return null;
    }
  }

  void setValor(Moeda moeda, double valorReais) {
    final item = find(moeda);

    if (item == null) {
      _items.add(CartItem(moeda: moeda, valorReais: valorReais));
    } else {
      item.valorReais = valorReais;
    }

    _items.removeWhere((i) => i.valorReais <= 0);
    notifyListeners();
  }

  void remove(Moeda moeda) {
    _items.removeWhere((i) => i.moeda.sigla == moeda.sigla);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
