import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../data/repositories/menu_repository.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuProvider extends ChangeNotifier {
  final MenuRepository _repository;

  MenuProvider(this._repository);

  MenuStatus _status = MenuStatus.initial;
  List<String> _categories = [];
  List<Product> _products = [];
  String? _error;

  MenuStatus get status => _status;
  List<String> get categories => _categories;
  List<Product> get products => _products;
  String? get error => _error;

  List<Product> productsByCategory(String category) =>
      _products.where((p) => p.category == category).toList();

  Future<void> load() async {
    _status = MenuStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.fetchCategories(),
        _repository.fetchProducts(),
      ]);
      _categories = results[0] as List<String>;
      _products   = results[1] as List<Product>;
      _status = MenuStatus.loaded;
    } catch (e) {
      _error  = e.toString();
      _status = MenuStatus.error;
    }
    notifyListeners();
  }
}
