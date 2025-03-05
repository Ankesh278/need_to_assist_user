import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/screens/cart_screen.dart';
import 'package:need_to_assist/view/screens/search_screen.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/service_provider.dart';
import '../widgets/custom_text_widget.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePage(),
      SearchScreen(),
       CartScreen(),
    ];
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: screens[navigationProvider.selectedIndex], // Dynamically switch between screens
      bottomNavigationBar:
      BottomNavigationBar(iconSize: 40,
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
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
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
  final Set<String> expandedCategories = {};
  bool isBooked = false;


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LocationProvider>(context, listen: false).loadSavedLocation(context);
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }


  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return WillPopScope(
        onWillPop: () async {
          return false; // Prevents navigating back to onboarding
        },
        child:
        Scaffold(
          backgroundColor: ColorUtils.background,
          appBar:
          AppBar(
            backgroundColor: Color(0xffF9F9F9),
            elevation: 0,
            leadingWidth: 250, // Increase the width to fit text properly
            leading: InkWell(
              onTap: () {
                Provider.of<NavigationProvider>(context, listen: false).navigateTo('/map');
              },
              child: Row(
                children: [
                  SizedBox(width: 10), // Adds some spacing from the left edge
                  Icon(Icons.home, size: 24),
                  SizedBox(width: 5), // Space between icon and text
                  Expanded(
                    child: CustomText(
                      text: locationProvider.currentAddress.isNotEmpty
                          ? locationProvider.currentAddress
                          : "Location Unavailable",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Ensures text does not overflow
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
                      padding: EdgeInsets.only(right: 10), // Ensures proper spacing
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2000,
                  child: Stack(
                    children: [
                      PositionedWidget(
                          top:0.h,left: 0.w,width: 390.w,height: 212.h,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                                color: Color(0xffF9F9F9),))),
                      PositionedWidget(
                          top: 60.h,
                          left: 23.w,
                          width:135.w, height: 90.h,
                          child: CustomText(
                            text: '"Expert laptop repair services for all brands and issues."',
                            fontWeight:FontWeight.w600 ,textAlign: TextAlign.start,
                            fontSize: 17.sp,)),
                      Positioned(
                          top: 40.h,
                          left: 182.w,
                          width: 208.w,height: 180.h,
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
                        child:
                        Container(
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
                              child:
                              ListView.builder(
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
                                              Provider.of<ServiceProvider>(context, listen: false)
                                                  .filterServicesByCategory(category.categoryName);
                                            },
                                            child: Container(
                                              width: 80.w,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(blue:0.2),
                                                    offset: Offset(0, 0),
                                                    blurRadius: 2.r,
                                                  ),
                                                ],
                                                color: ColorUtils.background,
                                              ),
                                              child: Center(
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:  category.categoryImage,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) {
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
                        child:
                        SizedBox(
                          width: 370.w, // Adjusted width to fit within the screen properly
                          height: 230.h, // Ensures proper height for ListView
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
                                          width: 150.w,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(blue:0.2),
                                                offset: Offset(0, 0),
                                                blurRadius: 2.r,
                                              ),
                                            ],
                                            color: Color(0xffF9F9FC),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.r),
                                            child: CachedNetworkImage(
                                              imageUrl:category.backgroundImage,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) {
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
                                          fontSize: 12.sp,
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
                        top: 630.h,
                        left: 19.w,
                        width: 352.w,
                        height: 3000.h,
                        child:
                        Consumer<ServiceProvider>(
                          builder: (context, serviceProvider, child) {
                            if (serviceProvider.filteredServices.isEmpty) {
                              return Center(
                                child: Text(
                                  "No service present",
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                ),
                              );
                            }

                            // Group services by category
                            Map<String, List<Service>> categorizedServices = {};
                            for (var service in serviceProvider.filteredServices) {
                              categorizedServices.putIfAbsent(service.categoryName, () => []).add(service);
                            }

                            return ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: categorizedServices.entries.map((entry) {
                                final categoryName = entry.key;
                                final services = entry.value;
                                final isExpanded = expandedCategories.contains(categoryName);
                                final displayedServices = isExpanded ? services : services.take(2).toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                      child: Text(
                                        categoryName,
                                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: displayedServices.length,
                                      itemBuilder: (context, index) {
                                        final service = displayedServices[index];
                                        return _buildServiceItem(service, context);
                                      },
                                    ),

                                    // "View More" or "View Less" button
                                    if (services.length > 2)
                                      Align(
                                        alignment: Alignment.centerRight
                                        ,child: TextButton(
                                          onPressed: () async{
                                            final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

                                            // Filter by category
                                            serviceProvider.filterServicesByCategory(categoryName);

                                            // Navigate to booking and reset filter when coming back
                                            await Navigator.pushNamed(context, '/booking');

                                            // Reset to show all services
                                            serviceProvider.resetFilter();
                                          },
                                          child: Text(
                                              "View More",
                                            style: TextStyle(
                                                color: Color(0xff27C300), fontSize: 14.sp),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        )
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
  Widget _buildServiceItem(Service service, BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = service.id;
    final isInCart = cartProvider.quantities.containsKey(productId);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
      child: Container(
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
                imageUrl: service.image,
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
                    text: service.name,
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
                        text: '* ${service.time} mins',
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
                        text: '₹ ${service.price}',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      Spacer(),

                      // Add / Remove Button
                      GestureDetector(
                        onTap: () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null)
                          {
                            if (isInCart) {
                              cartProvider.removeFromCart(context, user.uid, productId);
                              _showSnackbar(context, 'Item removed from cart', Colors.red);
                            } else {
                              cartProvider.addToCart(context, {
                                'id': service.id,
                                'name': service.name,
                                'price': service.price,
                                'categoryName': service.categoryName,
                                'image': service.image,
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
                            borderRadius: BorderRadius.circular(4.r),
                            color: Color(0xff404140),
                          ),
                          child: Center(
                            child: CustomText(
                              text: isInCart ? 'Remove' : 'Add',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),

                  // View Details
                  GestureDetector(
                    onTap: () {
                      Provider.of<NavigationProvider>(
                          context, listen: false)
                          .navigateTo(
                        '/detail',
                        arguments: {
                          'service': service
                        },
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
    );
  }

// Snackbar function
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




