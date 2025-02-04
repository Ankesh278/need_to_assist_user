import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
          List<Product> products = productJson
              .cast<Map<String, dynamic>>()
              .map((json) => Product.fromJson(json))
              .toList();

          // Save to local storage
          _saveProductsToCache(products);
          return products;
        } else {
          throw Exception('Invalid product data format');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // If API call fails, load from cache
      return _getProductsFromCache();
    }
  }

  Future<void> _saveProductsToCache(List<Product> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList =
    products.map((product) => json.encode(product.toJson())).toList();
    await prefs.setStringList('cached_products', productList);
  }

  Future<List<Product>> _getProductsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cachedData = prefs.getStringList('cached_products');

    if (cachedData != null) {
      return cachedData.map((jsonStr) {
        return Product.fromJson(json.decode(jsonStr));
      }).toList();
    }
    return [];
  }
}
