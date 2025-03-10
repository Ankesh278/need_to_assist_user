import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: CustomText(
          text: 'Help & Support',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            _buildSupportTile(Icons.chat, 'Live Chat', 'Get instant help from our support team.'),
            _buildSupportTile(Icons.phone, 'Call Support', 'Talk to a customer service representative.'),
            _buildSupportTile(Icons.email, 'Email Us', 'Send us an email for assistance.')

          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorUtils.primaryDark, size: 28.sp),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: subtitle,
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
