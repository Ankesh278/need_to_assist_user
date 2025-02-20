import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class DetailScreen extends StatefulWidget {
  final dynamic service;

  const DetailScreen({super.key, required this.service});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late dynamic service;

  @override
  void initState() {
    super.initState();
    service = widget.service;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9FC),
      body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 3350.h,
              child: Stack(
                      children: [
              PositionedWidget(
                top: 9.h,
                left: 4.w,
                width: 30.w,height: 30.h,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_sharp,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PositionedWidget(
                  top: 17.h,
                  left: 45.w,
                  width:201.w, height: 26.h,
                  child: CustomText(
                    text: 'Quick home booking',
                    fontWeight:FontWeight.w700,
                    fontSize: 20.sp,)),
              PositionedWidget(
                top: 154.h,
                left: 0.w,
                width:390.w, height: 756.h,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white,boxShadow: [BoxShadow(blurRadius: 2,offset: Offset(0, 0),color: Colors.black12,spreadRadius: 1),],
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30.r),topLeft: Radius.circular(30.r),)
                    )
                ),
              ),
              PositionedWidget(
                  top: 111.h,
                  left: 35.w,
                  width:325.w, height:87.h,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),boxShadow: [BoxShadow(
                            color: Colors.black12,blurRadius:2,offset: Offset(0,2),spreadRadius: 1
                        )]
                    ),
                    child: Row(children: [
                      Container(width: 107.w,height: 87.h,
                        decoration: BoxDecoration( color: Color(0xffAFAFAF),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),bottomLeft: Radius.circular(15.r))),child: Center(child:
                        Image.asset('assets/images/booking_screen/card1/1.png'),
                        ),),
                      SizedBox(width: 10.w,),
                      CustomText(text: '"Expert laptop repair\n services for all \n brands and issues."',fontSize: 17.sp,fontWeight: FontWeight.w500,textAlign: TextAlign.start,)

                    ],),
                  )
              ),
              PositionedWidget(top: 239.h, left: 19.w,width: 352.w,height: 515.h,
                  child:
                  Stack(
                    children: [
                      Container(
                        width: 352.w,
                        height: 140.h,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 0),
                              blurRadius: 2.r,
                            ),
                          ],
                          color: Color(0xffF9F9FC),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: CachedNetworkImage(
                                imageUrl: service.image,
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/default.png', fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 10.w),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: service.name,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  SizedBox(height: 8.h),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff5A5A5A), size: 18.sp),
                                      SizedBox(width: 5.w),
                                      CustomText(text: '2.5', fontSize: 10.sp),
                                      SizedBox(width: 5.w),
                                      CustomText(text: '4.5', fontSize: 10.sp),
                                      SizedBox(width: 20.w),
                                      CustomText(
                                        text: '* ${service.time} mins',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff666666),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: '₹ ${service.price}',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(width: 50.h,),
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<NavigationProvider>(context, listen: false).goBack();
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 35.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.sp),
                                            color: Color(0xffEAE8FE),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Book Now",
                                              fontSize: 14.sp,
                                              color: Color(0xff27C300),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

              ),

              PositionedWidget(top:391.h , left: 19.w, width: 352.w, height: 155.h, child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r)),
                child: Image.asset('assets/images/booking_screen/card1/2.png',colorBlendMode: BlendMode.difference,)
              ) ),
              PositionedWidget(top:401.h, left:31.w, width: 211.w, height: 32.h, child:CustomText(text: 'Book a ${service.name} service\nthrough online platforms.',fontSize: 13.sp,fontWeight: FontWeight.w600,color: Colors.white,) ),
              PositionedWidget(top:565.h, left:19.w, width: 250.w, height: 20.h, child:CustomText(text: '${service.name} Process ' ,fontSize: 15.sp,fontWeight: FontWeight.w600,) ),
                        ..._buildProcess(),
                        PositionedWidget(top:1260.h,
                            left:19.w, width: 280.w,
                            height: 20.h, child:CustomText(
                              text: 'Frequently Asked Questions (FAQs)' ,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,)),
                        ..._buildFAQs(),
                        PositionedWidget(top:2365.h,
                            left:17.w, width: 230.w,
                            height: 20.h, child:CustomText(
                              text: 'Disclaimer for Repair Services' ,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,)),
                        ..._buildDisclaimer(),
                        PositionedWidget(top:3210.h,
                            left:0.w, width: 390.w,
                            height: 115.h, child:Container(
                              color: Color(0xffE9EBED),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: 'Please Note -',fontWeight: FontWeight.w600,fontSize: 14.sp,),
                                    CustomText(
                                      text: 'Repair Quotation Will Provide after checkup\nSpare Parts are purchased separately at additional cost\nMotherboard repair, Fabrication and touchscreen will require taking\nthe laptop to the service shop\nHard disk, SSD will be return before the laptop taken to the service shop' ,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,color: Color(0xff666666),),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
            ),
          )),
    );

  }

  List<Widget> _buildProcess() {
    final  images = [
    '1.png',
    '2.png',
    '3.png',
    '4.png',
      '1.png',
      '2.png'
    ];

    return List.generate(
      service.repairProcesses.length, // Use the correct length
          (index) {
        final topOffset = 596.h + (110.h * index);
        final process = service.repairProcesses[index];

        return PositionedWidget(
          top: topOffset,
          left: 0.w,
          width: 390.w,
          height: 100.h,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffE9EBED),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
                children: [
                  SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: Image.asset(
                      'assets/images/details_screen/${images[index]}',
                    ),
                  ),
                  SizedBox(width: 8.w), // Add spacing between image and text
                  Expanded( // Ensures text takes available space and wraps
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: process.title,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                        ),
                        SizedBox(height: 4.h), // Space between title and description
                        CustomText(
                          text: process.description,
                          fontSize: 10.sp,
                          maxLines: 3,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff505050),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }
  List<Widget> _buildFAQs() {
    return List.generate(
      service.faqs.length,
          (index) {
        final topOffset = 1300.h + (120.h * index);
        final faq = service.faqs[index];

        return PositionedWidget(
          top: topOffset,
          left: 14.w,
          width: 362.w,
          height: 100.h,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text at the top
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 6.w,
                    height: 58.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(2.r),
                      ),
                      color: Color(0xff666666),
                    ),
                  ),
                ),
                SizedBox(width: 8.w), // Space between line and text
                Expanded( // Ensure text takes full space
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Prevent unnecessary stretching
                      children: [
                        CustomText(
                          text: faq.question,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                        ),
                        SizedBox(height: 4.h), // Add space between question and answer
                        CustomText(
                          text: faq.answer,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff505050),
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  List<Widget> _buildDisclaimer() {
    final heading = [
      '1. No Guarantee of Full Recovery',
      '2. Customer-Provided Parts',
      '3. No Guarantee of Success',
      '4. Risk of Additional Damage',
      '5. Data Loss',
      '6. Non-Original Parts',
      '7. Limited Warranty on Repairs',
      '8. Customer-Provided Parts',
      '9. Software Issues',
      '10. Acknowledgment and Agreement'
    ];

    final answer = [
      '> While we strive to provide the best possible repair services, motherboard repairs are complex and may not guarantee full restoration of the device’s functionality.',
      '> If customers provide parts for the repair, we are not responsible for the quality, compatibility, or performance of these components.',
      '> While we aim to resolve all issues during the repair process, there is no guarantee that the repair will restore the laptop to full functionality or resolve all underlying problems.',
      '> During the diagnostic and repair process, there is a potential risk of further damage to the laptop or its components. By proceeding with the repair, you acknowledge and accept this risk.',
      '> Repairs may involve actions that could result in the loss of stored data. Customers are strongly advised to back up all important data before leaving their device for repair. We are not liable for any data loss or corruption.',
      '> In some cases, replacement parts used for the repair may not be original or manufactured by the laptop’s brand. However, we ensure that all parts used are high-quality and compatible.',
      '> Repairs are covered by a limited warranty (if applicable) only for the specific issues addressed. This warranty does not cover unrelated issues or new problems that may arise after the repair.',
      '> If you supply parts for the repair, we are not responsible for the quality, compatibility, or performance of these parts.',
      '> Software-related problems, including operating system crashes or errors, may persist even after repairs and are not guaranteed to be resolved unless specifically addressed as part of the service.',
      '> By submitting your laptop for repair, you agree to the terms and conditions outlined in this disclaimer.'
    ];

    return List.generate(
      heading.length,
          (index) {
        final topOffset = 2400.h + (80.h * index);

        return PositionedWidget(
          top: topOffset,
          left: 17.w,
          width: 350.w,
          height: 110.h,
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 350.w, // Ensures text has enough space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
              children: [
                CustomText(
                  text: heading[index],
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 4.h), // Space between heading and answer
                CustomText(
                  text: answer[index],
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff505050),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
