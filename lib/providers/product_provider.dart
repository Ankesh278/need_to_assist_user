import 'package:flutter/material.dart';
import 'package:need_to_assist/models/product.dart';
import 'package:need_to_assist/repository/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productRepository.fetchProducts();
    } catch (e) {
      print("Error loading products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
