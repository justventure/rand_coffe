import '../../../core/api_client.dart';
import '../../../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchMyOrders();
  Future<Order> fetchOrder(String id);
  Future<Order> createOrder(List<Map<String, dynamic>> items);
  Future<Order> updateStatus(String id, String status);
  Future<void> deleteOrder(String id);
}

class RemoteOrderRepository implements OrderRepository {
  final ApiClient _api;
  RemoteOrderRepository(this._api);

  @override
  Future<List<Order>> fetchMyOrders() async {
    final data = await _api.get('/orders/my') as List;
    return data
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Order> fetchOrder(String id) async {
    final data = await _api.get('/orders/$id') as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  @override
  Future<Order> createOrder(List<Map<String, dynamic>> items) async {
    final data = await _api.post('/orders', body: {'items': items}) as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  @override
  Future<Order> updateStatus(String id, String status) async {
    final data = await _api.put('/orders/$id/status', body: {'status': status}) as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  @override
  Future<void> deleteOrder(String id) => _api.delete('/orders/$id');
}
