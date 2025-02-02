import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:need_to_assist/models/category.dart';

class CategoryRepository {
  final String baseUrl = 'http://15.207.112.43:8080/api/product/getcategory';

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['category'] != null) {
          final List<dynamic> categoriesJson = data['category'];
          return categoriesJson.cast<Map<String, dynamic>>().map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception('Invalid category data format');
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
