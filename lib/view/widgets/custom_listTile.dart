import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text_widget.dart';

class CustomListTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;

  const CustomListTile({
    Key? key,
    required this.imagePath,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:6.0, horizontal: 16.0),
        child: Row(
          children: [
            // Leading Image
            Image.asset(
              imagePath,
              width: 25.w,
              height: 25.h,

            ),
            const SizedBox(width: 16.0),
            // Title Text
            Expanded(
              child: CustomText(text:
                title,
                fontSize:15.sp ,fontWeight: FontWeight.w500,
              ),
            ),
            // Trailing Icon
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 12,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
