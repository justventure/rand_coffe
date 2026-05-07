import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  List<CartItem> get cartList => _items.values.toList();

  int getQuantity(String productId) => _items[productId]?.quantity ?? 0;

  bool inCart(String productId) => (_items[productId]?.quantity ?? 0) > 0;

  double get total => _items.values.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get totalCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      if (_items[product.id]!.quantity < 10) {
        _items[product.id]!.quantity++;
        notifyListeners();
      }
    } else {
      _items[product.id] = CartItem(product: product);
      notifyListeners();
    }
  }

  void remove(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity--;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
