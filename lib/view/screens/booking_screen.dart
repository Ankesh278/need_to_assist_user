import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  late List<Map<String, dynamic>> cardData = [];

  double totalCost = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (cardData.isEmpty && productProvider.products.isNotEmpty) {
      setState(() {
        cardData = productProvider.products.map((product) {
          return {
            'rating': 4.79,
            'value': '(1.5k)',
            'isAdded': false,
            'quantity': 1,
            'cost': double.parse(product.price),
          };
        }).toList();
      });
    }
  }
  void updateTotalCost() {
    setState(() {
      totalCost = cardData
          .where((card) => card['isAdded'])
          .fold(0.0, (sum, card) => sum + card['cost'] * card['quantity']);
    });
  }


  @override
  Widget build(BuildContext context) {
    print('hd');
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xffF9F9FC),
      bottomSheet: cardData.any((card) => card['isAdded'])
          ? Container(width: 390.w,
          height: 57.h,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6.r,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: '₹ $totalCost',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var card in cardData) {
                        card['isAdded'] = false;
                        card['quantity'] = 1;
                      }
                      totalCost = 0;
                    });
                    Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                      '/payment',
                    );

                  },
                  child: Container(
                    width: 65.sp,
                    height: 30.sp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: Color(0xff000000)),
                    alignment: Alignment.center,
                    child: CustomText(text: 'Done',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.white,),),
                )
              ])

      )
          : SizedBox.shrink(),
      body: SafeArea(child: Stack(
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
            height: 515.h,
            child: productProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : productProvider.products.isEmpty
                ? Center(child: Text('No products found'))
                : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: productProvider.products.length,
                physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 352.w,
                            height: 117.h,
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
                          ),
                          PositionedWidget(
                            top: 0.h,
                            left: 0.w,
                            width: 117.w,
                            height: 117.h,
                            child: Image.network(
                              product.productImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/default.png', fit: BoxFit.cover),
                            ),
                          ),
                          PositionedWidget(
                            top: 20.h,
                            left: 130.w,
                            width: 160.w,
                            height: 21.h,
                            child: CustomText(
                              text: product.productName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          PositionedWidget(
                            top: 50.h,
                            left: 130.w,
                            width: 15.w,
                            height: 15.h,
                            child: Icon(
                              Icons.star,
                              color: Color(0xff5A5A5A),
                              size: 20.sp,
                            ),
                          ),
                          PositionedWidget(
                            top: 52.h,
                            left: 152.w,
                            width: 52.w,
                            height: 12.h,
                            child: Row(
                              children: [
                                CustomText(
                                  text: cardData[index]['rating'].toString(),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                ),
                                SizedBox(width: 2),
                                CustomText(
                                  text: cardData[index]['value'].toString(),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 75.h,
                            left: 136.w,
                            child: CustomText(
                              text: '₹${product.price}',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Positioned(
                            top: 77.h,
                            left: 198.w,
                            child: CustomText(
                              text: '*${product.time} mins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff666666),
                            ),
                          ),
                          PositionedWidget(
                            top: 85.h,
                            left: 270.w,
                            width: 70.w,
                            height: 25.h,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cardData[index]['isAdded'] = !cardData[index]['isAdded'];
                                  updateTotalCost();
                                });
                              },
                              child: cardData[index]['isAdded']
                                  ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.sp),
                                  color: Color(0xffEAE8FE),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (cardData[index]['quantity'] > 0) {
                                            cardData[index]['quantity']--;
                                            if (cardData[index]['quantity'] == 0) {
                                              cardData[index]['isAdded'] = false;
                                            }
                                            updateTotalCost();
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        width: 17.sp,
                                        height: 17.sp,
                                        child: Icon(Icons.remove, size: 13.sp),
                                      ),
                                    ),
                                    Container(
                                      width: 17.w,
                                      height: 17.h,
                                      color: Colors.white,
                                      child: Center(
                                        child: CustomText(
                                          text: cardData[index]['quantity'].toString(),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          cardData[index]['quantity']++;
                                          cardData[index]['isAdded'] = true;
                                          updateTotalCost();
                                        });
                                      },
                                      child: SizedBox(
                                        width: 17.sp,
                                        height: 17.sp,
                                        child: Icon(Icons.add, size: 13.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: Color(0xff27C300)),
                                ),
                                alignment: Alignment.center,
                                child: Center(
                                  child: CustomText(
                                    text: 'ADD',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: Color(0xff27C300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PositionedWidget(
                            top: 100.h,
                            left: 135.w,
                            width: 55.w,
                            height: 14.h,
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                                  '/detail',
                                  arguments: {
                                    'cardData': cardData[index],
                                    'product': productProvider.products[index],
                                  },
                                );
                              },
                              child: CustomText(
                                text: 'View details',
                                color: Color(0xff27C300),
                                fontWeight: FontWeight.w500,
                                fontSize: 7.sp,
                              ),
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
}
