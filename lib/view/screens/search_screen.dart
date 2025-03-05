import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/keyboard_utils.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_formfield.dart';


class SearchScreen extends StatefulWidget {
   SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
      return false; // Prevents navigating back to onboarding
    },child:
      GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        dismissKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorUtils.background,
        body: SafeArea(
          child: Stack(
            children: [
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
      )
    );
  }
}
