import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/keyboard_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';
import '../widgets/custom_text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());
  int remainingTime = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<AuthProvider>(listen: false, context).sendOTP(widget.phoneNumber));
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void sendOtp() {
    Future.delayed(Duration.zero, () {
      Provider.of<AuthProvider>(context, listen: false).sendOTP;
    });
  }

  void verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otp = otpControllers.map((controller) => controller.text).join();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isSuccess = await authProvider.verifyOTP(otp);

    if (isSuccess) {
      Provider.of<NavigationProvider>(context, listen: false).navigateTo('/home');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isSuccess ? 'OTP Verified!' : 'Invalid OTP')),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    print('hello');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        dismissKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorUtils.background,
        body: SafeArea(
          child: Stack(
            children: [
              PositionedWidget(
                top: 19.h,
                left: 14.w,
                width: 30.w,height: 30.h,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_sharp,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
      PositionedWidget(top: 131.h, left: 137.w, width: 119.w, height:29.h, child: CustomText(text: 'Enter OTP',fontSize: 24.sp,fontWeight: FontWeight.w700,color: Color(0xff5A5A5A),)),
              PositionedWidget(top: 167.h, left: 110.w, width: 174.w, height:17.h, child: CustomText(text: 'OTP sent to ${widget.phoneNumber}',fontSize: 14.sp,fontWeight: FontWeight.w600,color: Color(0xffADA9A9),)),
              Form(
                key:_formKey ,
                child: PositionedWidget(top: 217.h,left: 50.w,width: 300.w,height: 36.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0,),
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:   TextFormField(
                            controller: otpControllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Selector<AuthProvider, bool>(
                selector: (_, provider) => provider.isResendEnabled,
                builder: (_, isResendEnabled, __) {
                  return PositionedWidget(
                    top: 272.h,
                    left: 118.w,
                    width: 158.w,
                    height: 19.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, size: 16.sp, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          isResendEnabled ? "Resend OTP Now" : "Resend OTP in 00:${remainingTime.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),

              PositionedWidget(top: 410.h, left: 52.w, width: 291.w, height: 38.h, child:
              GestureDetector(
                onTap: (){
                  verifyOtp();
                },
                child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(width: 1.sp),color: Color(0xff5A5A5A),),
                child: Center(child: CustomText(text: 'Verify OTP',color: Colors.white,fontWeight: FontWeight.w700,fontSize: 15.sp,))),
              )),
              // Bottom keyboard indicator

            ],
          ),
        ),
      ),
    );
  }
}

