import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
  Map<int, int> quantities = {};

  @override
  Widget build(BuildContext context) {
    final filteredServices = Provider.of<ServiceProvider>(context).filteredServices;
    double totalCost = 0;
    for (var entry in quantities.entries) {
      totalCost += filteredServices[entry.key].price * entry.value;
    }
    return Scaffold(
      backgroundColor: Color(0xffF9F9FC),
      body: SafeArea(
          child: Stack(
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
                                // Product Image
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

                                // Product Details
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
                                          SizedBox(width: 50.h,),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (!quantities.containsKey(index)) {
                                                  quantities[index] = 1;
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 100.w,
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.sp),
                                                color: Color(0xffEAE8FE),
                                              ),
                                              child: quantities.containsKey(index)
                                                  ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (quantities[index]! > 1) {
                                                          quantities[index] = quantities[index]! - 1;
                                                        } else {
                                                          quantities.remove(index);
                                                        }
                                                      });
                                                    },
                                                    child: Icon(Icons.remove, size: 20.sp),
                                                  ),
                                                  Container(
                                                    width: 25.w,
                                                    height: 25.h,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: CustomText(
                                                        text: quantities[index].toString(),
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        quantities[index] = quantities[index]! + 1;
                                                      });
                                                    },
                                                    child: Icon(Icons.add, size: 20.sp),
                                                  ),
                                                ],
                                              )
                                                  : Center(
                                                child: CustomText(
                                                  text: "Add",
                                                  fontSize: 14.sp,
                                                  color: Color(0xff27C300),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      // View Details
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
      bottomSheet: quantities.isNotEmpty
          ? Container(
        height: 80.h,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Total: ₹ $totalCost',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/payment', arguments: {'totalCost': totalCost});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text('Done',style: const TextStyle(color: Colors.white),),
            ),
          ],
        ),
      )
          : null,
    );
  }
}
