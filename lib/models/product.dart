class Product {
  final int? id;
  final String name;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      // Handle both String and double for price
      price: json['price'] is String
          ? double.parse(json['price'])
          : json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
