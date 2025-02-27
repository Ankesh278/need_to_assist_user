import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_text_widget.dart';
import 'calendar.dart';

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

      await Provider.of<CartProvider>(context, listen: false)
          .fetchCartProducts(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final cartId = cartProvider.cartId;

    double totalCost =
    cartItems.fold(0, (sum, item) => sum + ((item['price'] as num?) ?? 0));

    return Scaffold(
      backgroundColor: ColorUtils.background,
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _getCurrentUserAndFetchCart, // ✅ Pull to refresh cart items
        child: cartItems.isEmpty
            ? const Center(child: Text("No items in cart"))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final String? imageUrl = item['image']; // ✅ Fetch image URL

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // ✅ Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            )
                                : Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // ✅ Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: item['name'] ?? 'Unknown Item',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text: "₹${(item['price'] ?? 0)}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),

                          // ✅ Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () async {
                              if (userId != null) {
                                await Provider.of<CartProvider>(context,
                                    listen: false)
                                    .deleteCartItem(
                                    userId!, item['ProductId']);
                                _getCurrentUserAndFetchCart(); // ✅ Refresh cart after deletion
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ✅ Checkout Section
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300, blurRadius: 5),
                  ],
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Show Total Cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Total: ₹${totalCost.toStringAsFixed(2)}",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Checkout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cartItems.isEmpty || cartId == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChooseSlotScreen(
                                    totalCost: totalCost,
                                    cartId: cartId,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Proceed to Checkout",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
