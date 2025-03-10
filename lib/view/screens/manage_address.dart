import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  _ManageAddressScreenState createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};
  List<Map<String, String>> addresses = [
    {'title': 'Home', 'address': '123 Main Street, City, Country'},
    {'title': 'Work', 'address': '456 Office Road, City, Country'},
    {'title': 'Other', 'address': '789 Another Place, City, Country'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: CustomText(
          text: 'Manage Addresses',
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
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  controllers.putIfAbsent(
                      index, () => TextEditingController(text: addresses[index]['address']));
                  return _buildAddressTile(index);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  addresses.add({'title': 'New', 'address': ''});
                  int newIndex = addresses.length - 1;
                  controllers[newIndex] = TextEditingController();
                  isEditing[newIndex] = true;
                });
              },
              child: Container(
                width: double.infinity,
                height: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Center(
                  child: CustomText(
                    text: 'Add New Address',
                    color: ColorUtils.primaryDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTile(int index) {
    return ListTile(
      leading: Icon(Icons.location_on, color: Colors.black54),
      title: CustomText(
        text: addresses[index]['title']!,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      subtitle: isEditing[index] == true
          ? TextField(
        controller: controllers[index],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        ),
        onSubmitted: (value) {
          setState(() {
            addresses[index]['address'] = value;
            isEditing[index] = false;
          });
        },
      )
          : CustomText(
        text: addresses[index]['address']!,
        fontSize: 14.sp,
        color: Colors.black54,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 18.sp, color: Colors.black38),
            onPressed: () {
              setState(() {
                isEditing[index] = !(isEditing[index] ?? false);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 18.sp, color: Colors.red),
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
                controllers.remove(index);
                isEditing.remove(index);
              });
            },
          ),
        ],
      ),
    );
  }
}
