import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';
import '../widgets/custom_listTile.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffE9EBED),
        elevation: 0,
        title: CustomText(text: 'Help & Support', fontSize: 20.sp, fontWeight: FontWeight.w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomListTile(imagePath: 'assets/images/default.png', title: 'FAQs'),
            Divider(color: Colors.grey.shade300),
            CustomListTile(imagePath: 'assets/images/default.png', title: 'Contact Support'),
            Divider(color: Colors.grey.shade300),
            CustomListTile(imagePath: 'assets/images/default.png', title: 'Terms & Conditions'),
            Divider(color: Colors.grey.shade300),
            CustomListTile(imagePath: 'assets/images/default.png', title: 'Privacy Policy'),
            Divider(color: Colors.grey.shade300),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement contact support logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                ),
                child: CustomText(text: 'Contact Support', fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
