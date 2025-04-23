import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  final Map<String, int> _quantities = {};
  List<Map<String, dynamic>> get cartItems => _cartItems;
  Map<String, int> get quantities => _quantities;
  String? _cartId;
  Future<void> fetchCartProducts(String userId) async {
    final url =Uri.parse('http://needtoassist.com/api/user/getcartitem/$userId');
    if (kDebugMode) {
      print("USerId  $userId");
    }
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (kDebugMode) {
          print("Fetched Data: $decodedData");
        }
        if (decodedData.containsKey('cart')) {
          _cartId = decodedData['cart']['_id'];
          if (decodedData['cart'] is Map<String, dynamic>) {
            _cartItems = List<Map<String, dynamic>>.from(
                decodedData['cart']['products'] ?? []);
          } else {
            _cartItems = [];
          }
        } else {
          _cartItems = [];
          if (kDebugMode) {
            print("Key 'cart' not found in response");
          }
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching products: $e");
      }
    }
  }
  String? get cartId => _cartId;
  Future<void> deleteCartItem(String userId, String productId) async {
    print("USer Id "+userId    +"Product id  "+productId);
    final url =
        Uri.parse('http://needtoassist.com/api/user/cart/$userId/$productId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print("Respponse code "+response.statusCode.toString());
        final decodedData = json.decode(response.body);
        print("DATAA>>>>   "+decodedData);
        if (kDebugMode) {
          print("Delete Response: $decodedData");
        }
        _cartItems.removeWhere((item) => item['ProductId'] == productId);
        notifyListeners();
        if (kDebugMode) {
          print(decodedData['message']);
        }
      } else {
        throw Exception('Failed to delete cart item');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting cart item: $e");
      }
    }
  }
  /// **Add to Cart or Increase Quantity**
  Future<void> addToCart(BuildContext context, Map<String, dynamic> service) async {
    final url = Uri.parse('https://needtoassist.com/api/user/cart');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showLoginDialog(context);
      return;
    }
    final userId = user.uid;
    final productId = service['id'];
    if (_quantities.containsKey(productId)) {
      _quantities[productId] = _quantities[productId]! + 1;
    } else {
      _quantities[productId] = 1;
    }
    notifyListeners();

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
        if (kDebugMode) {
          print("Service added to cart: $decodedResponse");
        }
      } else {
        if (kDebugMode) {
          print("Failed to add service: $decodedResponse");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  /// **Decrease Quantity or Remove from Cart**
  Future<void> removeFromCart(BuildContext context, String userId, String productId) async {
    print("Method executed");

    // Check if the product exists in the quantities map
    if (!_quantities.containsKey(productId) || _quantities[productId] == 0) {
      return;
    }

    _quantities[productId] = _quantities[productId]! ;
    if (_quantities[productId] == 0) {
      _quantities.remove(productId);
    }
    notifyListeners();
    String api = "http://needtoassist.com/api/user/cart/$userId/$productId";
    final url = Uri.parse(api);
    print("API url: $api");

    try {

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
        }),
      );

      if (response.statusCode == 200) {
        print("Response code: ${response.statusCode}");
        if (kDebugMode) {
          print("Item removed from cart.");
        }
      } else {
        // Handle non-200 responses
        if (kDebugMode) {
          print("Failed to remove item, Status Code: ${response.statusCode}");
          print("Response Body: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
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
