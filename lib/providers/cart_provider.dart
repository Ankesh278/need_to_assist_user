import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  Future<void> fetchCartItems(String userId) async {
    final url = Uri.parse('http://15.207.112.43:8080/api/user/getcartitem/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        print("Fetched Data: $decodedData"); // Debugging: Print API response

        if (decodedData.containsKey('cart')) {
          if (decodedData['cart'] is List) {
            _cartItems = List<Map<String, dynamic>>.from(decodedData['cart']);
          } else if (decodedData['cart'] is Map<String, dynamic>) {
            _cartItems = [decodedData['cart']];
          } else {
            _cartItems = [];
          }
        } else {
          _cartItems = [];
          print("Key 'cart' not found in response");
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print("Error fetching cart: $e");
    }
  }

  Future<void> deleteCartItem(String userId, String productId) async {
    final url = Uri.parse('http://15.207.112.43:8080/api/user/cart/$userId/$productId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print("Delete Response: $decodedData"); // Debugging: Print delete response

        _cartItems.removeWhere((item) => item['ProductId'] == productId);
        notifyListeners();
        print(decodedData['message']);
      } else {
        throw Exception('Failed to delete cart item');
      }
    } catch (e) {
      print("Error deleting cart item: $e");
    }
  }
}
