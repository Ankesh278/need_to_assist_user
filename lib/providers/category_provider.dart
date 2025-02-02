import 'package:flutter/material.dart';
import 'package:need_to_assist/models/category.dart';
import 'package:need_to_assist/repository/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _categoryRepository = CategoryRepository();
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryRepository.fetchCategories();
    } catch (e) {
      print("Error loading categories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
