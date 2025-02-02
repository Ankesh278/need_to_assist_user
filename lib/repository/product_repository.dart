import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:need_to_assist/models/product.dart';

class ProductRepository {
  final String baseUrl = 'http://15.207.112.43:8080/api/product/getproduct';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['products'] != null) {
          final List<dynamic> productJson = data['products'];
          return productJson.cast<Map<String, dynamic>>().map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Invalid product data format');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
