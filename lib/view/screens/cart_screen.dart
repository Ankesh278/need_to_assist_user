import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/navigation_provider.dart';
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
    final locationProvider = Provider.of<LocationProvider>(context);
    final cartItems = cartProvider.cartItems;
    final cartId = cartProvider.cartId;
    double totalCost = cartItems.fold(0, (sum, item) => sum + ((item['price'] as num?) ?? 0) * ((item['quantity'] as num?) ?? 1));
    return PopScope(
        canPop: false,
        child:
      Scaffold(
        backgroundColor: ColorUtils.background,
        appBar:
        AppBar(
          backgroundColor: Color(0xffF9F9F9),
          elevation: 0,
          leadingWidth: 250,
          leading: InkWell(
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).navigateTo('/map');
            },
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.home, size: 24),
                SizedBox(width: 5),
                Expanded(
                  child: CustomText(
                    text: locationProvider.currentAddress.isNotEmpty
                        ? locationProvider.currentAddress
                        : "Location Unavailable",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Provider.of<NavigationProvider>(context, listen: false).navigateTo('/profile');
                      },
                      child: Icon(Icons.person, size: 30),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      body:
      RefreshIndicator(
        onRefresh: _getCurrentUserAndFetchCart,
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
                  final String? imageUrl = item['image'];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, color: Colors.grey),
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.shopping_cart, color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: item['name'] ?? 'Unknown Item',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 6),
                                CustomText(
                                  text: "Category: ${item['category'] ?? 'N/A'}",
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                CustomText(
                                  text: "Quantity: ${item['quantity'] ?? 1}",
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                CustomText(
                                  text: "₹${(item['price'] ?? 0) * (item['quantity'] ?? 1)}",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            tooltip: 'Remove Item',
                            onPressed: ()async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Remove Item"),
                                  content: const Text("Are you sure you want to remove this item from your cart?"),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Remove")),
                                  ],
                                ),
                              );
                              if (confirm == true && userId != null) {
                                print("Item is pressed");
                                await Provider.of<CartProvider>(context, listen: false)
                                    .removeFromCart(context,userId!,  item["ProductId"]);
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
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cartItems.isEmpty || cartId == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseSlotScreen(
                                totalCost: totalCost,
                                cartId: cartId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Proceed to Checkout", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      )
    );
  }
}
