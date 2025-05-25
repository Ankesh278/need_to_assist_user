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
    final url =Uri.parse('https://needtoassist.com/api/user/getcartitem/$userId');
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
            _cartItems = List<Map<String, dynamic>>.from(decodedData['cart']['products'] ?? []);

            // 🛠️ Initialize _quantities from the fetched cart items
            _quantities.clear(); // clear old data
            for (var item in _cartItems) {
              final productId = item['ProductId']?.toString();
              final quantity = item['quantity'] ?? 1;
              if (productId != null) {
                _quantities[productId] = quantity;
              }
            }
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
    debugPrint("USer Id ${userId}Product id  $productId");
    final url =
        Uri.parse('https://needtoassist.com/api/user/cart/$userId/$productId');
    try {
      final response = await http.post(
        url,
       // headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        debugPrint("Response code ${response.statusCode}");
        final decodedData = json.decode(response.body);
        debugPrint("DATA>>>>   $decodedData");
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
      debugPrint("Response code  ${response.statusCode}");
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = json.decode(responseBody);
      debugPrint("Response body  $decodedResponse");
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
    debugPrint("=========== removeFromCart() ===========");
    debugPrint("User ID: $userId");
    debugPrint("Product ID to remove: $productId");
    debugPrint("Full _quantities map: $_quantities");
    debugPrint("Type of productId: ${productId.runtimeType}");
    debugPrint("Keys in _quantities: ${_quantities.keys.toList()}");

    // Check if the product exists in the map and has quantity > 0
    bool containsKey = _quantities.containsKey(productId);
    int? quantity = _quantities[productId];

    debugPrint("Contains key: $containsKey");
    debugPrint("Quantity for $productId: $quantity");

    // Also check if it exists in cartItems
    bool existsInCartItems = _cartItems.any((item) => item['ProductId'].toString() == productId);
    debugPrint("Exists in _cartItems list: $existsInCartItems");
    debugPrint("Full _cartItems list: $_cartItems");

    // Final condition before returning
    if (!containsKey || quantity == null || quantity == 0) {
      debugPrint("❌ Product not found in _quantities OR quantity is already zero. Exiting method.");
      return;
    }

    // Decrement quantity
    _quantities[productId] = quantity - 1;
    debugPrint("✅ Decremented quantity. New quantity for $productId: ${_quantities[productId]}");

    // Remove if quantity becomes zero
    if (_quantities[productId] == 0) {
      _quantities.remove(productId);
      debugPrint("🗑️ Quantity is 0. Removed $productId from _quantities.");

      _cartItems.removeWhere((item) {
        bool shouldRemove = item['ProductId'].toString() == productId;
        if (shouldRemove) {
          debugPrint("🗑️ Removing item from _cartItems: $item");
        }
        return shouldRemove;
      });
    }

    notifyListeners();

    // Prepare the API call
    final url = Uri.parse("https://needtoassist.com/api/user/cart/$userId/$productId");

    debugPrint("🌐 Sending POST request to: $url");
    debugPrint("Request Headers: ${{'Content-Type': 'application/json'}}");
    debugPrint("NOTE: No body is being sent with this request.");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // body: json.encode({'userId': userId, 'productId': productId}),
      );

      debugPrint("✅ Response status code: ${response.statusCode}");
      debugPrint("✅ Response body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("✅ Item successfully removed from server cart.");
        await fetchCartProducts(userId);
      } else {
        debugPrint("❌ Failed to remove item. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❗ Exception while calling API: $e");
    }

    debugPrint("=========== End removeFromCart() ===========");
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
