import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final navigationProvider =
    Provider.of<NavigationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      navigationProvider.navigateTo('/map');
                    },
                    child: CustomText(
                      text: 'Skip',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset(
                  'assets/images/login_screen/login_ds1.png',
                  width: 265.w,
                  height: 265.h,
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/login_screen/India.png',
                      width: 31.w,
                      height: 31.h,
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: '+91',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 5.w),
                    Icon(Icons.keyboard_arrow_down_sharp, size: 15),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Consumer<AuthProvider>(
                        builder: (context, provider, child) {
                          return TextFormField(
                            controller: provider.phoneController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Enter Number',
                              hintStyle: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff7D7D7D),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                GestureDetector(
                  onTap: () async {
                    final phoneNumber =
                    authProvider.phoneController.text.trim();
                    if (phoneNumber.isEmpty ||
                        !RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text('Enter a valid 10-digit phone number')),
                      );
                      return;
                    }
                    final fullPhoneNumber =
                        "+91${authProvider.phoneController.text.trim()}";
                    await authProvider.sendOTP(fullPhoneNumber, context: context);
                    navigationProvider.navigateTo('/otp',
                        arguments: {'phoneNumber': phoneNumber});
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.sp),
                    ),
                    child: Center(
                      child: CustomText(text: 'Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
