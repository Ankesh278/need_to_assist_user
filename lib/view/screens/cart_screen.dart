import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_text_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserAndFetchCart();
  }

  Future<void> _getCurrentUserAndFetchCart() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      Provider.of<CartProvider>(context, listen: false).fetchCartItems(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    // ✅ Fix: Handle null prices safely
    double totalCost = cartItems.fold(0, (sum, item) => sum + ((item['price'] as num?) ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("No items in cart"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Colors.black),
                  title: CustomText(
                    text: item['name'] ?? 'Unknown Item',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: CustomText(
                    text: "₹${(item['price'] ?? 0)}", // ✅ Fix: Avoid null price
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async{
                      if (userId != null) {
                        await Provider.of<CartProvider>(context, listen: false)
                            .deleteCartItem(userId!, item['ProductId']);
                      }
                      // Implement delete functionality if required
                    },
                  ),
                );
              },
            ),
          ),

          // ✅ Checkout Button
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ Show Total Cost
                  CustomText(
                    text: "Total: ₹${totalCost.toStringAsFixed(2)}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  // ✅ Checkout Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/payment', // ✅ Navigate to Payment Screen
                        arguments: {'totalCost': totalCost}, // Pass total cost
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
