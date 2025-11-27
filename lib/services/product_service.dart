import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'category': category,
    'image': imageUrl,
  };
}

class ProductService {
  final String baseUrl = 'https://690e7aa2bd0fefc30a048fe0.mockapi.io/products';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar joias');
    }
  }

  Future<void> addProduct(Product product) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
  }

  Future<void> updateProduct(String id, Product product) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
  }

  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}