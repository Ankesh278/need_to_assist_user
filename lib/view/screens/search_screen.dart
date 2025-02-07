import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import  'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/utils/keyboard_utils.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_formfield.dart';


class SearchScreen extends StatelessWidget {
   SearchScreen({super.key});
TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {

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
                top: 30.h,
                left: 7.w,
                width: 30.w,height: 30.h,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_sharp,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PositionedWidget(top: 30.h, left: 43.w, width:329.w, height: 47.h, child:CustomTextFormField(
                controller: searchController,
                labelText: "Search",
                hintText: 'Search for services',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter something to search';
                  }
                  return null;
                },
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
