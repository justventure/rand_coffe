import '../../../core/api_client.dart';
import '../../../models/product.dart';

abstract class MenuRepository {
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProducts();
  Future<List<Product>> fetchProductsByCategory(String category);
}

class RemoteMenuRepository implements MenuRepository {
  final ApiClient _api;
  RemoteMenuRepository(this._api);

  Future<List<Map<String, dynamic>>> _fetchRaw() async {
    final data = await _api.get('/categories') as List;
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<String>> fetchCategories() async {
    final data = await _fetchRaw();
    return data.map((e) => e['name'].toString()).toList();
  }

  @override
  Future<List<Product>> fetchProducts() async {
    final data = await _fetchRaw();
    final products = <Product>[];
    for (final category in data) {
      final categoryName = category['name'].toString();
      final categoryProducts = category['products'] as List? ?? [];
      for (final p in categoryProducts) {
        products.add(Product.fromJson(p as Map<String, dynamic>, categoryName: categoryName));
      }
    }
    return products;
  }

  @override
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final all = await fetchProducts();
    return all.where((p) => p.category == category).toList();
  }
}
