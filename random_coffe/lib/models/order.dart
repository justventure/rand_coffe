import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == value.toUpperCase(),
    );
  }

  String toJson() => name.toUpperCase();
}

class OrderItem extends Equatable {
  final String id;
  final String productId;
  final int quantity;
  final int price;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id:        json['id'] as String,
      productId: json['productId'] as String,
      quantity:  json['quantity'] as int,
      price:     json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':        id,
    'productId': productId,
    'quantity':  quantity,
    'price':     price,
  };

  @override
  List<Object?> get props => [id, productId, quantity, price];
}

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final int totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id:         json['id'] as String,
      userId:     json['userId'] as String,
      items:      (json['items'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status:     OrderStatus.fromString(json['status'] as String),
      totalPrice: json['totalPrice'] as int,
      createdAt:  DateTime.parse(json['createdAt'] as String),
      updatedAt:  DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':         id,
    'userId':     userId,
    'items':      items.map((e) => e.toJson()).toList(),
    'status':     status.toJson(),
    'totalPrice': totalPrice,
    'createdAt':  createdAt.toIso8601String(),
    'updatedAt':  updatedAt.toIso8601String(),
  };

  Order copyWith({
    String?       id,
    String?       userId,
    List<OrderItem>? items,
    OrderStatus?  status,
    int?          totalPrice,
    DateTime?     createdAt,
    DateTime?     updatedAt,
  }) {
    return Order(
      id:         id         ?? this.id,
      userId:     userId     ?? this.userId,
      items:      items      ?? this.items,
      status:     status     ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt:  createdAt  ?? this.createdAt,
      updatedAt:  updatedAt  ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, items, status, totalPrice, createdAt, updatedAt];
}
