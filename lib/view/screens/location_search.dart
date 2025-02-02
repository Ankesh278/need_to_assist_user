import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_formfield.dart';
import 'map_screen.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Focus(
            // This ensures the focus is managed properly
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent, // Makes sure taps are detected everywhere
              child: Stack(
                children: [
                  PositionedWidget(
                    top: 9.h,
                    left: 4.w,
                    width: 30.w,
                    height: 30.h,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PositionedWidget(
                    top: 123.h,
                    left: 32.w,
                    width: 329.w,
                    height: 47.h,
                    child: CustomTextFormField(
                      controller: searchController,
                      labelText: "Search for your location",
                      hintText: 'Search',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the location';
                        }
                        return null;
                      },
                    ),
                  ),
                  PositionedWidget(
                    top: 182.h,
                    left: 46.w,
                    width: 10.w,
                    height: 10.h,
                    child: Icon(
                      Icons.my_location_outlined,
                      color: Color(0xff0063C5),
                      size: 12,
                    ),
                  ),
                  PositionedWidget(
                    top: 182.h,
                    left: 62.w,
                    width: 87.w,
                    height: 11.h,
                    child: CustomText(
                      text: 'Use current location',
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
                      color: Color(0xff0063C5),
                    ),
                  ),
                  PositionedWidget(
                    top: 664.h,
                    left: 75.w,
                    width: 240.w,
                    height: 49.h,
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                          '/map',
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(width: 1.sp),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Continue',
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
