import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  Map<String, int> _quantities = {};
  List<Map<String, dynamic>> get cartItems => _cartItems;
  Map<String, int> get quantities => _quantities;
  String? _cartId; // Add a variable to store cartId

  Future<void> fetchCartProducts(String userId) async {
    final url = Uri.parse(
        'http://15.207.112.43:8080/api/user/getcartitem/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        print("Fetched Data: $decodedData"); // Debugging: Print API response

        if (decodedData.containsKey('cart')) {
          _cartId = decodedData['cart']['_id']; // Extract cartId

          if (decodedData['cart'] is Map<String, dynamic>) {
            _cartItems = List<Map<String, dynamic>>.from(
                decodedData['cart']['products'] ?? []);
          } else {
            _cartItems = [];
          }
        } else {
          _cartItems = [];
          print("Key 'cart' not found in response");
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  String? get cartId => _cartId; // Getter for cartId


  Future<void> deleteCartItem(String userId, String productId) async {
    final url = Uri.parse(
        'http://15.207.112.43:8080/api/user/cart/$userId/$productId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print(
            "Delete Response: $decodedData"); // Debugging: Print delete response
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

  /// **Add to Cart or Increase Quantity**
  Future<void> addToCart(BuildContext context, Map<String, dynamic> service) async {
  final url = Uri.parse('http://15.207.112.43:8080/api/user/cart');
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
  _showLoginDialog(context);
  return;
  }
  final userId = user.uid;
  final productId = service['id'];

  // Increase the quantity in UI state
  if (_quantities.containsKey(productId)) {
  _quantities[productId] = _quantities[productId]! + 1;
  } else {
  _quantities[productId] = 1;
  }
  notifyListeners();

  // API Call
  final request = http.MultipartRequest('POST', url);
  request.fields['userId'] = userId;
  request.fields['ProductId'] = productId;
  request.fields['name'] = service['name'];
  request.fields['price'] = service['price'].toString();
  request.fields['category'] = service['categoryName'];
  request.fields['image'] = service['image'];
  request.fields['quantity'] = _quantities[productId].toString();

  try {
  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  final decodedResponse = json.decode(responseBody);

  if (response.statusCode == 201) {
  print("Service added to cart: $decodedResponse");
  } else {
  print("Failed to add service: $decodedResponse");
  }
  } catch (e) {
  print("Error: $e");
  }
  }

  /// **Decrease Quantity or Remove from Cart**
  Future<void> removeFromCart(BuildContext context, String userId, String productId) async {
  if (!_quantities.containsKey(productId) || _quantities[productId] == 0) return;

  _quantities[productId] = _quantities[productId]! - 1;
  if (_quantities[productId] == 0) {
  _quantities.remove(productId);
  }
  notifyListeners();

  final url = Uri.parse('http://15.207.112.43:8080/api/user/cart/$userId/$productId');
  try {
  final response = await http.post(url, headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
  print("Item removed from cart.");
  } else {
  print("Failed to remove item.");
  }
  } catch (e) {
  print("Error: $e");
  }
  }

  /// **Show Login Dialog**
  void _showLoginDialog(BuildContext context) {
  showDialog(
  context: context,
  builder: (context) => AlertDialog(
  title: Text('Login Required'),
  content: Text('Please log in to proceed with booking.'),
  actions: [
  TextButton(
  onPressed: () => Navigator.pop(context),
  child: Text('OK'),
  ),
  ],
  ),
  );
  }
  }

