import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/screens/notification_screen.dart';
import 'package:need_to_assist/view/screens/search_screen.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/category_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/product_provider.dart';

import '../widgets/custom_text_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomePage(),
      const SearchScreen(),
      const NotificationScreen(),
    ];
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: _screens[navigationProvider.selectedIndex], // Dynamically switch between screens
      bottomNavigationBar: BottomNavigationBar(iconSize: 40,
        backgroundColor: ColorUtils.background,
        currentIndex: navigationProvider.selectedIndex,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontFamily: 'Inter',fontSize: 9.sp,fontWeight: FontWeight.w600),
        unselectedItemColor: Color(0xff8B8B8B),
        unselectedIconTheme: IconThemeData(size: 40),
        unselectedLabelStyle:TextStyle(fontFamily: 'Inter',fontSize: 9.sp,fontWeight: FontWeight.w600) ,
        onTap: (index)=>navigationProvider.setIndex(index),
        items:  [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Image.asset('assets/images/home_screen/navigation_icon/home.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom:10.0),
              child: Image.asset('assets/images/home_screen/navigation_icon/2.png'),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon:Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset('assets/images/home_screen/navigation_icon/1.png'),
            ),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {


  late List<Map<String, dynamic>> cardData = [];

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

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: SafeArea(
        child:
        Stack(children: [
          PositionedWidget(top:0.h,left: 0.w,width: 390.w,height: 212.h,
              child: Container(decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                color: Color(0xffF9F9F9),))),
          PositionedWidget(
            top: 9.h,
            left: 4.w,
            width: 30.w,height: 30.h,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_sharp,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          PositionedWidget(
              top: 23.h,
              left: 50.w,
              width: 10.w,height: 10.h,
              child:Image.asset('assets/images/home_screen/card1/locator.png',)
          ),
          PositionedWidget(
              top: 21.h,
              left: 65.w,
              width:88.w, height: 14.h,
              child: CustomText(
                text: 'Guru Nanak Nagar',
                fontWeight:FontWeight.w400 ,
                fontSize: 10.sp,)),
          PositionedWidget(
              top: 16.h,
              left: 340.w,
              width: 40.w,height: 40.h,
              child:GestureDetector(
                onTap: (){
                  Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                    '/profile',
                  );

                },
                  child: SizedBox(width: 40,height: 40 ,
                      child: Image.asset('assets/images/home_screen/card1/customer_care.png',)))
          ),
          PositionedWidget(
              top: 97.h,
              left: 23.w,
              width:135.w, height: 90.h,
              child: CustomText(
                text: '"Expert laptop repair services for all brands and issues."',
                fontWeight:FontWeight.w600 ,textAlign: TextAlign.start,
                fontSize: 17.sp,)),
          PositionedWidget(
              top: 25.h,
              left: 182.w,
              width: 208.w,height: 208.h,
              child:Image.asset('assets/images/home_screen/card1/home1.png',)
          ),
          PositionedWidget(
              top: 230.h,
              left: 13.w,
              width:84.w, height: 15.h,
              child: CustomText(
                text: 'Select Service',
                fontWeight:FontWeight.w600 ,
                fontSize: 12.sp,)),
          PositionedWidget(
            top: 254.h,
            left: 6.w,
            width: 379.w,
            height: 140.h,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w), // Added padding
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: categoryProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : categoryProvider.categories.isEmpty
                  ? Center(child: Text('No categories found'))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: categoryProvider.categories.length,
                    shrinkWrap: true, // Ensures proper height adjustment
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        child: SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                                    '/service',
                                    arguments: {
                                      'cardData': cardData[index],
                                      'product': productProvider.products[index],
                                      'category': categoryProvider.categories[index],
                                    },
                                  );
                        },
                                child: Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                    color: ColorUtils.background,
                                  ),
                                  child: Center(
                                    child: ClipOval(
                                      child: Image.network(
                                        category.categoryImage,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/default.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              CustomText(
                                text: category.categoryName,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 410.h,
            left: 8.w,
            child: SizedBox(
              width: 370.w, // Adjusted width to fit within the screen properly
              height: 150.h, // Ensures proper height for ListView
              child: categoryProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : categoryProvider.categories.isEmpty
                  ? Center(child: Text('No categories found'))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorUtils.background, // Light background for contrast
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h), // Added padding
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: categoryProvider.categories.length,
                    shrinkWrap: true, // Prevents layout overflow
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          children: [
                            Container(
                              width: 86.w,
                              height: 115.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  category.backgroundImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/default.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            CustomText(
                              text: category.categoryName,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center, // Ensures proper text alignment
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 560.h,
            left: 19.w,
            width: 352.w,
            height: 200.h,
            child: productProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : productProvider.products.isEmpty
                ? Center(child: Text('No products found'))
                : Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: productProvider.products.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 352.w,
                          height: 117.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 2),
                                blurRadius: 4.r,
                              ),
                            ],
                            color: Color(0xffF9F9FC),
                          ),
                        ),
                        Positioned(
                          left: 0.w, width: 117.w,
                          height: 117.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9.r),
                            child: Image.network(
                              product.productImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/default.png', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20.h,
                          left: 130.w,
                          child: CustomText(
                            text: product.productName,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        Positioned(
                          top: 50.h,
                          left: 130.w,
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Color(0xff5A5A5A), size: 18.sp),
                              SizedBox(width: 4.w),
                              CustomText(
                                text:cardData[index]['rating'].toString() ,
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
                        Positioned(
                          top: 85.h,
                          left: 280.w,
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<NavigationProvider>(context, listen: false).navigateTo('/booking');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.r),
                                color: Color(0xff404140),
                              ),
                              child: CustomText(
                                text: 'Book',
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )

        ],
        )
      ),
    );
  }
}
