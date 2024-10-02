import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String apiUrl = 'http://localhost:8000/api/products';

  // Mendapatkan semua produk
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((product) => Product.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  // Membuat produk baru
  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  // Memperbarui produk
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${product.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // Menghapus produk
  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
