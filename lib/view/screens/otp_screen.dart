import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/keyboard_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  int remainingTime = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<AuthProvider>(context, listen: false).sendOTP(widget.phoneNumber, context: context));
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

  void verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final otp = otpControllers.map((controller) => controller.text).join();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isSuccess = await authProvider.verifyOTP(otp);

    if (isSuccess) {
      Provider.of<NavigationProvider>(context, listen: false).navigateAndRemoveUntil('/map');
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
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => dismissKeyboard(context),
      child: Scaffold(
        backgroundColor: ColorUtils.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_sharp),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 100.h),
                Center(child: CustomText(text: 'Enter OTP', fontSize: 24.sp, fontWeight: FontWeight.w700, color: Color(0xff5A5A5A))),
                SizedBox(height: 10.h),
                Center(child: CustomText(text: 'OTP sent to ${widget.phoneNumber}', fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xffADA9A9))),
                SizedBox(height: 40.h),
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 40.w,  // Increase width slightly
                          height: 40.h,  // Increase height slightly
                          decoration: BoxDecoration(
                            color: Color(0xffD9D9D9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: otpControllers[index],
                              keyboardType: TextInputType.number,
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 20.sp,  // Make text bigger
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,  // Ensure no extra padding
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                                }
                              },
                              validator: (value) => value == null || value.isEmpty ? "" : null,
                            ),
                          ),
                        );

                    }),
                  ),
                ),
                SizedBox(height: 20.h),
                Selector<AuthProvider, bool>(
                  selector: (_, provider) => provider.isResendEnabled,
                  builder: (_, isResendEnabled, __) {
                    return Center(
                      child: GestureDetector(
                        onTap: isResendEnabled
                            ? () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .sendOTP(widget.phoneNumber, context: context);
                          setState(() {
                            remainingTime = 30;
                            startTimer();
                          });
                        }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer, size: 16.sp, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              isResendEnabled
                                  ? "Resend OTP Now"
                                  : "Resend OTP in 00:${remainingTime.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: isResendEnabled ? Colors.blue : Colors.black,
                                decoration: isResendEnabled ? TextDecoration.underline : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 50.h),
                GestureDetector(
                  onTap: verifyOtp,
                  child: Container(
                    width: double.infinity,
                    height: 38.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1.sp),
                      color: Color(0xff5A5A5A),
                    ),
                    child: Center(
                      child: CustomText(text: 'Verify OTP', color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.sp),
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
