import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/providers/navigation_provider.dart';
import 'package:need_to_assist/view/screens/booking_history.dart';
import 'package:need_to_assist/view/screens/help_support.dart';
import 'package:need_to_assist/view/widgets/custom_position_widget.dart';
import 'package:need_to_assist/view/widgets/custom_text_widget.dart';
import 'package:need_to_assist/viewModel/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_listTile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVM=Provider.of<ProfileViewModel>(context);
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body:
        SafeArea(child: Stack(children: [
          PositionedWidget(top: 0.h, left:0.h,width:394.w, height: 201.h, child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.r),),color: Color(0xffE9EBED)
            ),
          )),
          PositionedWidget(
            top: 30.h,
            left: 7.w,
            width: 40.w,
            height: 40.h,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          PositionedWidget(
            top: 95.h,
            left: 148.w,
            width: 97.w,
            height: 26.h,
            child: CustomText(text: 'My Profile',fontSize: 20.sp,fontWeight: FontWeight.w600,)
          ),
          PositionedWidget(
              top: 158.h,
              left: 60.w,
              width:282.w, height:81.h,
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),boxShadow: [BoxShadow(
                        color: Colors.black12,blurRadius:2,offset: Offset(0,2),spreadRadius: 1
                    )]
                ),
              )
          ),
          PositionedWidget(top: 174.h, left: 70.h, width: 50.w, height: 50.h, child: CircleAvatar(
            radius: 25,
              foregroundImage: profileVM.profile.imageUrl.isNotEmpty
                  ? NetworkImage(profileVM.profile.imageUrl):
              const AssetImage('assets/images/profile_screen/profile.png') as ImageProvider

          )),
          PositionedWidget(
              top: 188.h,
              left: 131.w,
              width: 100.w,
              height: 20.h,
              child: CustomText(text: profileVM.profile.name,fontSize: 15.sp,fontWeight: FontWeight.w600,)
          ),
          PositionedWidget(top: 186.h, left: 282.w, width: 30.w, height:30.h, child:
          GestureDetector(
            onTap: (){
              _showEditDialog(context);
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r),color: Color(0xffD9D9D9)),
              child: Icon(Icons.edit,size: 18.sp,),
            ),
          )),
          PositionedWidget(
              top: 266.h,
              left: 28.w,
              width: 339.w,
              height: 194.h,
              child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: Color(0xffffffff),boxShadow: [BoxShadow(
                  color: Colors.black12,blurRadius:2,offset: Offset(0,2),spreadRadius: 1
              )]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpSupportScreen()));
                        },
                          child: CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/1.png',title: 'Help & Support',)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 16.w,),
                        height: 1.h,color: Color(0xffD9D9D9),),
                      GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingHistoryScreen()));
                      },
                          child: CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/2.png',title: 'My bookings',)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                        height: 1.h,color: Color(0xffD9D9D9),),
                      CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/3.png',title: 'Manage addresses',),Container(margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                        height: 1.h,color: Color(0xffD9D9D9),),
                      CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/4.png',title: 'Manage payment methods',),
                    ],
                  )
              )
          ),
          PositionedWidget(
              top: 482.h,
              left: 28.w,
              width: 339.w,
              height: 114.h,
              child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: Color(0xffffffff),boxShadow: [BoxShadow(
                  color: Colors.black12,blurRadius:2,offset: Offset(0,2),spreadRadius: 1
              )]),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/5.png',title: 'Settings',),
                      Container(margin: EdgeInsets.symmetric(horizontal: 16.w,),
                        height: 1.h,color: Color(0xffD9D9D9),),
                      CustomListTile(imagePath: 'assets/images/profile_screen/leading_icon/6.png',title: 'About',),
                    ],
                  )
              )
          ),
          PositionedWidget(
          top: 708.h,
    left: 28.w,
    width: 339.w,
    height: 45.h,
    child:GestureDetector(
      onTap: (){
Provider.of<AuthProvider>(context,listen:false).logout(context);
Provider.of<NavigationProvider>(context,listen:false).navigateAndRemoveUntil('/login');
      },
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: Color(0xffffffff),boxShadow: [BoxShadow(
      color: Colors.black12,blurRadius:2,offset: Offset(0,2),spreadRadius: 1
      )]),child: Center(child: CustomText(text: 'Log Out',color: Color(0xffFD0000),fontWeight: FontWeight.w500,fontSize: 15.sp,)),),
    ))
        ],))
    );
  }
  void _showEditDialog(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    TextEditingController nameController = TextEditingController(text: profileVM.profile.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => profileVM.updateProfileImage(),
              child: const Text('Change Profile Picture'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              profileVM.updateProfileName(nameController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
