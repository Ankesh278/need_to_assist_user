import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../providers/category_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/custom_text_widget.dart';


class ServiceDetail extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final Product product;
  final Category category;
  const ServiceDetail({super.key, required this.product, required this.cardData, required this.category});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center,
                child: Text('List of ${category.categoryName} Services')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(width: 390.w,
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
                                    text: '4.5 (1.5k)',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
