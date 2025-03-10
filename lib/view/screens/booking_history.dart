import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  final List<Map<String, dynamic>> bookingHistory = const [
    {
      "title": "Software Installation",
      "date": "March 10, 2025",
      "status": "Completed",
      "icon": Icons.build,
    },
    {
      "title": "Laptop Repair",
      "date": "March 8, 2025",
      "status": "Pending",
      "icon": Icons.laptop_mac,
    },
    {
      "title": "Data Recovery",
      "date": "March 5, 2025",
      "status": "In Progress",
      "icon": Icons.storage,
    },
    {
      "title": "Virus Removal",
      "date": "March 2, 2025",
      "status": "Completed",
      "icon": Icons.security,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: CustomText(
          text: 'Booking History',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ListView.builder(
          itemCount: bookingHistory.length,
          itemBuilder: (context, index) {
            final booking = bookingHistory[index];
            return _buildBookingTile(
              booking["title"],
              booking["date"],
              booking["status"],
              booking["icon"],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingTile(String title, String date, String status, IconData icon) {
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
            offset: const Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color:ColorUtils.primaryDark, size: 28.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: date,
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: status,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(status),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
