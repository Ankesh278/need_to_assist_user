import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/custom_text_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: SafeArea(
        child: Stack(
            children:[
              PositionedWidget(top:-98.h, left: -28.w,
                width:445.w ,height:370.5.h ,
                child: Image.asset('assets/images/splash_screen/Ellipse_9.png',
                    width:445.w ,height:370.5.h),),
              PositionedWidget(top:46.h, left: 116.w,
                width:157.w ,height:87.h ,
                child: Image.asset('assets/images/splash_screen/logo.png'),),
              PositionedWidget(
                top: 218.h,left: 17.w,width: 355.w,height: 355.h,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                  Consumer<OnboardingProvider>(
                    builder: (
                        context, onboardingProvider, child) {
                      return Image.asset(
                        onboardingProvider.illustrations[onboardingProvider.currentScreenIndex],
                        key: ValueKey<int>(onboardingProvider.currentScreenIndex),
                      );
                    },
                  ),
                ),
              ),
              PositionedWidget(top: 606.h, left: 61.w,
                width: 268.w,
                height: 75.h,
                child: CustomText(
                  text:
                  'Book a laptop repair\nappointment via the app and\nenjoy doorstep assistance.',
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  color: ColorUtils.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              PositionedWidget(
                top: MediaQuery.of(context).size.height - 140.h, // Adjust dynamically
                left: (MediaQuery.of(context).size.width - 87.w) / 2, // Center horizontally
                width: 120.w,
                height: 30.h, // Increase height for better visibility
                child: Consumer<OnboardingProvider>(
                  builder: (context,provider,child) {
                    return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                    provider.illustrations.length,
                    (index) => Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Container(width: 27.w,height: 9.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(55.r),
                    color: provider.currentScreenIndex == index ? Color(0xff666666 ) : ColorUtils.primary,))
                    ),
                    ));
                  }
                ),
              ),

              PositionedWidget(top: 750.h,left: 300.w,width: 50.w,height: 50.h,
                  child: GestureDetector(
                      onTap:(){
                        FocusScope.of(context).unfocus();
                        Provider.of<NavigationProvider>(context, listen: false).navigateTo('/login');
                         },child: Image.asset('assets/images/splash_screen/Back_Arrow.png'))
              ),

            ]
        ),
      ),
    );
  }
}