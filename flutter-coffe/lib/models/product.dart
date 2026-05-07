class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String? imageUrl;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json, {required String categoryName}) => Product(
    id: json['id'].toString(),
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    category: categoryName,
    imageUrl: json['imageUrl'] as String?,
    description: json['description'] as String?,
  );
}
