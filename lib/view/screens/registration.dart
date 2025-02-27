import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';

import '../../models/user_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_formfield.dart';
import '../widgets/custom_text_widget.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController=TextEditingController();
    TextEditingController emailController=TextEditingController();
    TextEditingController addressController=TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Future<void> saveUserData() async {
      UserModel user = UserModel(
        name: nameController.text,
        email: emailController.text,
        address: addressController.text,
        phoneNumber: "9120715587", // Replace with actual user phone
      );
      await userProvider.saveUserData(user);
    }

    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: SafeArea(child: Stack(
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
      PositionedWidget(top: 74.h, left: 72.w, width: 266.w, height:26.h, child: CustomText(text: 'Complete Your Registration',fontSize: 20.sp,fontWeight: FontWeight.w600,color: Color(0xff000000),)),
      PositionedWidget(top: 192.h, left: 32.w, width:329.w, height: 47.h, child:CustomTextFormField(
    controller: nameController,
    labelText: "What's your full name?",
    hintText: 'Enter name',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your full name';
      }
      return null;
    },
      ),),
      PositionedWidget(top: 270.h, left: 32.w, width:329.w, height: 47.h, child:CustomTextFormField(
    controller: emailController,
    labelText: "What's your Email?",
    hintText: 'Enter Email',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your valid email';
      }
      return null;
    },
      ),
      ),
      PositionedWidget(top: 348.h, left: 32.w, width:329.w, height: 47.h, child:CustomTextFormField(
    controller: addressController,
    labelText: "What's your Address?",
    hintText: 'Enter Address',
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your address';
      }
      return null;
    },
        onFieldSubmitted: (value){
      FocusScope.of(context).unfocus();
        },
      ),),
      PositionedWidget(top: 664.h, left: 75.w, width: 240.w, height: 49.h, child: GestureDetector(
          onTap: () async{
            await saveUserData();
            Provider.of<NavigationProvider>(context, listen: false).navigateAndRemoveUntil(
              '/home',);
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r),border: Border.all(width: 1.sp),color: Colors.black),
            child: Center(child:
            CustomText(
              text: 'Continue',
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,)),))
      ),
    ],
      )),
    );
  }
}