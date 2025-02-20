import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
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
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: ColorUtils.background,
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SafeArea(
            child: Focus(
              child: Container(
                width: double.infinity,height: double.infinity,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    PositionedWidget(top: 42.h, left: 325.w, width:40.w, height: 25.h, child: GestureDetector(
                        onTap: (){
                          Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                            '/map',
                          );

                        },
                        child: CustomText(text: 'Skip',fontWeight:FontWeight.w500 ,fontSize: 15.sp,))),
                    PositionedWidget(top: 6.h, left: 58.w, width: 265.w, height:265.h , child:Image.asset('assets/images/login_screen/login_ds1.png')),
                    PositionedWidget(top: 306.h, left: 32.w, width: 31.w, height: 31.h, child:Image.asset('assets/images/login_screen/India.png')),
                    PositionedWidget(top: 337.h, left: 66.w, width: 288.w, height: 0.h, child: Container(
                      decoration: BoxDecoration(border:Border(top: BorderSide(color: Color(0xff5A5A5A),width: 1.w) )),
                    )),
                    PositionedWidget(top: 314.h, left: 66.w, width: 24.w, height: 16.h, child: CustomText(text: '+91',fontSize: 13.sp,fontWeight: FontWeight.w700,)),
                    PositionedWidget(top: 316.h, left: 88.w, width: 15.w, height: 15.h, child:Icon(Icons.keyboard_arrow_down_sharp,size: 15,)),
                    Positioned(
                      top: 323.h,
                      left: 97.w,
                      child: Transform.rotate(
                        angle: -90 * (3.14159 / 180), // Convert degrees to radians
                        child: Container(
                          width: 18.w, // Set width before rotation
                          height: 0.h, // Set height before rotation
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff5A5A5A), // Set color of the line
                                width: 1.w, // Set thickness of the line
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),                PositionedWidget(
                      top: 316.h,
                      left: 88.w,
                      width: 15.w,
                      height: 15.h,
                      child: Icon(Icons.keyboard_arrow_down_sharp, size: 15),
                    ),
                    PositionedWidget(
                      top: 315.h,
                      left: 111.w,
                      width: 120.w,
                      height: 15.h,
                      child: Consumer<AuthProvider>(
                        builder: (context, provider, child) {
                          return TextFormField(
                            controller: provider.phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
                              FilteringTextInputFormatter.digitsOnly, // Only allow numbers
                              LengthLimitingTextInputFormatter(10),   // Limit to 10 digits
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty || !RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),

                    PositionedWidget(top: 337.h, left: 66.w, width: 288.w, height: 0.h, child: Container(
                      decoration: BoxDecoration(border:Border(top: BorderSide(color: Color(0xff5A5A5A),width: 1.w) )),)),
                    PositionedWidget(
                      top: 410.h,
                      left: 52.w,
                      width: 291.w,
                      height: 38.h,
                      child: GestureDetector(
                        onTap: () async {
                          final phoneNumber = authProvider.phoneController.text.trim();
                          if (phoneNumber.isEmpty || !RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter a valid 10-digit phone number')),
                            );
                            return;
                          }
                          final fullPhoneNumber = "+91${authProvider.phoneController.text.trim()}";
                          await authProvider.sendOTP(fullPhoneNumber);
                          navigationProvider.navigateTo('/otp', arguments: {'phoneNumber': phoneNumber});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1.sp),
                          ),
                          child: Center(
                            child: CustomText(text: 'Continue'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}