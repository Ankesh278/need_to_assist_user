import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../widgets/custom_text_widget.dart';


class ServiceScreen extends StatefulWidget {
  final String selectedCategory;
   ServiceScreen({required this.selectedCategory, Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {

  List<dynamic> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final url = Uri.parse("http://needtoassist.com/api/product/getproduct"); // Replace with API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> products = data['products'];

      // Filter products based on selected category
      setState(() {
        _services = products
            .where((product) => product['categoryName'] == widget.selectedCategory)
            .toList();
        _isLoading = false;

      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print("Failed to load services");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorUtils.background,
      appBar: AppBar(title: Text(widget.selectedCategory),backgroundColor: ColorUtils.background,), // Category name as title
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _services.isEmpty
          ? Center(child: Text("No services found"))
          : ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
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
                        'http://needtoassist.com/${service['image']}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/default.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20.h,
                    left: 130.w,
                    child: CustomText(
                      text: service['name'],
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
                          text:'4.79' ,
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                        ),
                        SizedBox(width: 2),
                        CustomText(
                          text: '(1.5k)',
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
                      text: '₹${service['price']}',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Positioned(
                    top: 77.h,
                    left: 198.w,
                    child: CustomText(
                      text: '*${service['time']} mins',
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
    );
  }
}
