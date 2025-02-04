import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
          List<Category> categories = categoriesJson.cast<Map<String, dynamic>>()
              .map((json) => Category.fromJson(json))
              .toList();

          // Save to local storage
          _saveCategoriesToCache(categories);
          return categories;
        } else {
          throw Exception('Invalid category data format');
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs, try fetching cached data
      return _getCategoriesFromCache();
    }
  }

  Future<void> _saveCategoriesToCache(List<Category> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> categoryList =
    categories.map((category) => json.encode(category.toJson())).toList();
    await prefs.setStringList('cached_categories', categoryList);
  }

  Future<List<Category>> _getCategoriesFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cachedData = prefs.getStringList('cached_categories');

    if (cachedData != null) {
      return cachedData.map((jsonStr) {
        return Category.fromJson(json.decode(jsonStr));
      }).toList();
    }
    return [];
  }
}
