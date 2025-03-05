import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/screens/cart_screen.dart';
import 'package:need_to_assist/view/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/service_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class BookingScreen extends StatefulWidget {

  const BookingScreen({super.key,});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}
class _BookingScreenState extends State<BookingScreen> {




  @override
  Widget build(BuildContext context) {
    final filteredServices = Provider
        .of<ServiceProvider>(context)
        .filteredServices;
    return Scaffold(
      backgroundColor: Color(0xffF9F9FC),
      body: SafeArea(
          child:
          Stack(
            children: [
              PositionedWidget(
                top: 9.h,
                left: 4.w,
                width: 30.w,
                height: 30.h,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_sharp,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PositionedWidget(
                  top: 17.h,
                  left: 45.w,
                  width: 201.w,
                  height: 26.h,
                  child: CustomText(
                    text: 'Quick home booking',
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,)),
              PositionedWidget(
                top: 154.h,
                left: 0.w,
                width: 390.w,
                height: 756.h,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 2,
                              offset: Offset(0, 0),
                              color: Colors.black12,
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.r),
                          topLeft: Radius.circular(30.r),)
                    )
                ),
              ),
              PositionedWidget(
                  top: 111.h,
                  left: 35.w,
                  width: 325.w,
                  height: 87.h,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                            spreadRadius: 1
                        )
                        ]
                    ),
                    child: Row(children: [
                      Container(width: 107.w,
                        height: 87.h,
                        decoration: BoxDecoration(color: Color(0xffAFAFAF),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.r),
                                bottomLeft: Radius.circular(15.r))),
                        child: Center(child:
                        Image.asset('assets/images/booking_screen/card1/1.png'),
                        ),),
                      SizedBox(width: 10.w,),
                      CustomText(
                        text: '"Expert laptop repair\n services for all \n brands and issues."',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,)

                    ],),
                  )
              ),
              PositionedWidget(
                  top: 239.h,
                  left: 17.w,
                  width: 188.w,
                  height: 21.h,
                  child: CustomText(
                    text: 'Select Service Category',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,)),
              PositionedWidget(
                top: 290.h,
                left: 17.w,
                width: 352.w,
                height: 450.h,
                child: filteredServices.isEmpty
                    ? Center(child: Text('No products found'))
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: filteredServices.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final product = filteredServices[index];
                    final cartProvider = Provider.of<CartProvider>(context);
                    final productId = product.id;
                    final isInCart = cartProvider.quantities.containsKey(productId);

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 352.w,
                                height: 140.h,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 0),
                                      blurRadius: 2.r,
                                    ),
                                  ],
                                  color: Color(0xffF9F9FC),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl: product.image,
                                        width: 100.w,
                                        height: 100.h,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/images/default.png', fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: product.name,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              Icon(Icons.star, color: Color(0xff5A5A5A), size: 18.sp),
                                              SizedBox(width: 5.w),
                                              CustomText(text: '2.5', fontSize: 10.sp),
                                              SizedBox(width: 5.w),
                                              CustomText(text: '4.5', fontSize: 10.sp),
                                              SizedBox(width: 20.w),
                                              CustomText(
                                                text: '* ${product.time} mins',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff666666),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              CustomText(
                                                text: '₹ ${product.price}',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  final user = FirebaseAuth.instance.currentUser;
                                                  if (user != null) {
                                                    if (isInCart) {
                                                      cartProvider.removeFromCart(context, user.uid, productId);
                                                      _showSnackbar(context, 'Item removed from cart', Colors.red);
                                                    } else {
                                                      cartProvider.addToCart(context, {
                                                        'id': product.id,
                                                        'name': product.name,
                                                        'price': product.price,
                                                        'categoryName': product.categoryName,
                                                        'image': product.image,
                                                      });
                                                      _showSnackbar(context, 'Item added to cart', Colors.green);
                                                    }
                                                  }
                                                  else{
                                                    _showLoginDialog(context);
                                                  }
                                                },
                                                child: Container(
                                                  width: 100.w,
                                                  height: 35.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4.sp),
                                                    color: Color(0xff404140),
                                                  ),
                                                  child: Center(
                                                    child: CustomText(
                                                      text: isInCart ? 'Remove' : 'Add',
                                                      fontSize: 14.sp,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                                                '/detail',
                                                arguments: {'service': filteredServices[index]},
                                              );
                                            },
                                            child: CustomText(
                                              text: 'View details',
                                              color: Color(0xff27C300),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          )),

    );
  }
  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text:'Login Required'),
        backgroundColor: ColorUtils.background,
        content: CustomText(text: 'Please log in to proceed with booking.'),
        actions: [
          TextButton(
            onPressed: () => Provider.of<NavigationProvider>(context, listen: false).navigateTo('/login'),
            child: CustomText(text:'OK'),
          ),
        ],
      ),
    );
  }
}