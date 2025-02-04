import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/product.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final Product product;

  const DetailScreen({super.key, required this.cardData, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9FC),
      body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 2550.h,
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
                      children:[ Container(
                        width: 352.w,
                        height: 117.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          boxShadow:[ BoxShadow(color: Colors.black.withOpacity(0.2),offset: Offset(0,0),blurRadius: 2.r,
                          )],
                          color: Color(0xffF9F9FC),
                        ),
                      ),
                        PositionedWidget(top: 0.h, left: 0.w, width:117.w , height: 117.h, child:
                        Image.network(
                          product.productImage, fit: BoxFit.cover,
                          errorBuilder: (context, error,
                              stackTrace) =>
                              Image.asset('assets/images/default.png',
                                fit: BoxFit.cover,),
                        ),),
                        PositionedWidget(top:20.h, left: 130.w, width:160.w, height:21.h, child: CustomText(
                          text: product.productName,fontWeight: FontWeight.w600,fontSize: 16.sp,)),
                        PositionedWidget(top:50.h, left: 130.w, width:15.w, height:15.h, child:Icon(Icons.star,color: Color(0xff5A5A5A),size: 20.sp,)),
                        PositionedWidget(top:52.h, left: 152.w, width:52.w, height:12.h, child: Row(
                          children: [
                            CustomText(text: cardData['rating'].toString(),fontWeight: FontWeight.w400,fontSize: 10.sp,),SizedBox(width: 2,),
                            CustomText(text: cardData['value'].toString(),fontWeight: FontWeight.w400,fontSize: 10.sp,),
                          ],
                        )),
                        Positioned(
                          top: 75.h,
                          left: 136.w,
                          child: CustomText(
                            text: '₹${product.price}',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Positioned(
                          top: 77.h,
                          left: 198.w,
                          child: CustomText(
                            text: '*${product.time} mins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                          ),
                        ),
                        PositionedWidget(top:85.h, left: 270.w, width: 70.w, height: 25.h, child: cardData['isAdded']?
                        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.sp),color: Color(0xffEAE8FE)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 17.sp,height: 17.sp,
                                  child: Icon(Icons.remove,size: 13.sp,)),
                              Container(width: 17.w,height: 17.h,color: Colors.white,
                                  child: Center(child: CustomText(text:cardData['quantity'].toString(),fontSize: 12.sp,fontWeight: FontWeight.w400,))),
                              SizedBox(width: 17.sp,height: 17.sp,
                                  child: Icon(Icons.add,size: 13.sp,))
                            ],),
                        ):
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r),border: Border.all(color: Color(0xff27C300)) ),alignment: Alignment.center,
                          child:Center(child: CustomText(text: 'ADD',fontWeight: FontWeight.w400,fontSize: 14.sp,color: Color(0xff27C300),)),)),
                      ]
                  )
              ),
              PositionedWidget(top:391.h , left: 19.w, width: 352.w, height: 155.h, child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r)),
                child: Image.asset('assets/images/booking_screen/card1/2.png',colorBlendMode: BlendMode.difference,)
              ) ),
              PositionedWidget(top:401.h, left:31.w, width: 211.w, height: 32.h, child:CustomText(text: 'Book a ${product.productName} service\nthrough online platforms.',fontSize: 13.sp,fontWeight: FontWeight.w600,color: Colors.white,) ),
              PositionedWidget(top:565.h, left:19.w, width: 250.w, height: 20.h, child:CustomText(text: '${product.productName} Process ' ,fontSize: 15.sp,fontWeight: FontWeight.w600,) ),
                        ..._buildProcess(),
                        PositionedWidget(top:940.h,
                            left:19.w, width: 280.w,
                            height: 20.h, child:CustomText(
                              text: 'Frequently Asked Questions (FAQs)' ,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,)),
                        ..._buildFAQs(),
                        PositionedWidget(top:1880.h,
                            left:17.w, width: 230.w,
                            height: 20.h, child:CustomText(
                              text: 'Disclaimer for Repair Services' ,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,)),
                        ..._buildDisclaimer(),
                        PositionedWidget(top:2410.h,
                            left:0.w, width: 390.w,
                            height: 105.h, child:Container(
                              color: Color(0xffE9EBED),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: 'Please Note -',fontWeight: FontWeight.w600,fontSize: 10.sp,),
                                    CustomText(
                                      text: 'Repair Quotation Will Provide after checkup\nSpare Parts are purchased separately at additional cost\nMotherboard repair, Fabrication and touchscreen will require taking\nthe laptop to the service shop\nHard disk, SSD will be return before the laptop taken to the service shop' ,
                                      fontSize: 8.sp,
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
    ];
    final heading = [
      'Laptop Check-Up',
      'Spare Parts Purchase (If Required)',
      'Laptop Repair',
      'Payment'
    ];
    final content=[
'> The technician will thoroughly inspect your laptop to diagnose the issue.\n> A detailed diagnosis and cost estimate will be provided before proceeding with the repair',
      '> If any parts need replacement, the technician will procure high-quality, compatible spare parts.\n> Customers will be informed about the parts and their cost before purchase to ensure transparency.',
      '> Repairs will be performed on-site in your presence for complete transparency and trust.\n> The technician will test the laptop after the repair to confirm the issue has been resolved.',
      '> Settle the final bill, which will include only the agreed spare parts and repair charges .'
    ];

    return List.generate(
      images.length,
          (index) {
        final topOffset = 596.h + (85.h * index);
        return PositionedWidget(
          top: topOffset,
          left: 0.w,
          width: 390.w,
          height: 70.h,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffE9EBED),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: Image.asset(
                        'assets/images/details_screen/${images[index]}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: heading[index],fontWeight: FontWeight.w600,fontSize: 12.sp,),
                          CustomText(text: content[index],fontSize:6.sp ,fontWeight: FontWeight.w500,color: Color(0xff505050),)
                        ],
                      ),
                    )
                  ]
              ),
            ),
          ),
        );
      },
    );
  }
  List<Widget> _buildFAQs() {
    final questions = [
      '1. How long does a laptop repair take?',
      '2. Do I need to back up my data before repair?',
      '3. What types of laptop issues do you repair?',
      '4. Do you provide on-site repair services?',
      '5. How much will the repair cost?',
      '6. Do you use original parts for replacements?',
      '7. What if my laptop cannot be repaired?',
      '8. Is there a warranty on the repairs?',
      '9. Do you provide data recovery services?'
    ];
    final content = [
      '> The duration of the repair depends on the nature of the issue. Minor repairs (like software\ntroubleshooting or cleaning) can often be completed on the same day, while complex repairs]\n(such as motherboard replacement) may take 2-5 business days.',
      '> Yes, we strongly recommend backing up all important data before submitting your laptop.\nAlthough we take precautions, we cannot guarantee data safety during repair.',
      'We handle a wide range of issues, including:\n> Hardware problems (e.g., screen, keyboard, battery, motherboard)\n> Software issues (e.g., OS crashes, virus removal)\n> Performance optimization and upgrades\n> Data recovery',
      '> Yes, we offer on-site repair for certain issues, such as minor software problems or hardware\nreplacement. For more complex repairs, the laptop may need to be taken to our workshop.',
      '> The cost depends on the diagnosis and required repairs. A quote will be provided after\ninspection, and no additional charges will be made without your approval.',
      '> Whenever possible, we use original parts. If not available, we use high-quality compatible\nparts with warranties. Customers are informed beforehand.',
      '> If the laptop cannot be repaired, we will inform you immediately and suggest alternative\nsolutions, such as data recovery or component replacement. Diagnostic fees may still apply.',
      '> Yes, we offer a warranty on most repairs and replacement parts. The warranty duration\ndepends on the type of repair and the parts used.',
      '> Yes, we can recover data from laptops with failed operating systems, damaged hard drives,\nor other issues. Data recovery is subject to evaluation and is charged separately.'
    ];
    return List.generate(
      questions.length,
          (index) {
        final topOffset = 980.h + (100.h * index);
        return PositionedWidget(
          top: topOffset,
          left: 14.w,
          width: 362.w,
          height: 83.h,
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
                children: [
Container(width: 6.w,height: 58.h,
  decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(right: Radius.circular(2.r),),color: Color(0xff666666)
),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: questions[index],fontWeight: FontWeight.w600,fontSize: 12.sp,),
                    CustomText(text: content[index],fontSize:7.sp ,fontWeight: FontWeight.w500,color: Color(0xff505050),)
                  ],
                ),
              )
              ]
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
      '> While we strive to provide the best possible repair services, motherboard repairs are\ncomplex and may not guarantee full restoration of the devices functionality.',
      '> If customers provide parts for the repair, we are not responsible for the quality, compatibility,\nor performance of these components.',
      '> While we aim to resolve all issues during the repair process, there is no guarantee that the\nrepair will restore the laptop to full functionality or resolve all underlying problems.',
      '> During the diagnostic and repair process, there is a potential risk of further damage to the\nlaptop or its components. By proceeding with the repair, you acknowledge and accept this\nrisk.',
      '> Repairs may involve actions that could result in the loss of stored data. Customers are\nstrongly advised to back up all important data before leaving their device for repair. We are\nnot liable for any data loss or corruption.',
      '> In some cases, replacement parts used for the repair may not be original or manufactured by\nthe laptop’s brand. However, we ensure that all parts used are high-quality and compatible.',
      '> Repairs are covered by a limited warranty (if applicable) only for the specific issues\naddressed. This warranty does not cover unrelated issues or new problems that may arise\nafter the repair.',
      '> If you supply parts for the repair, we are not responsible for the quality, compatibility, or\nperformance of these parts.',
      '> Software-related problems, including operating system crashes or errors, may persist even\nafter repairs and are not guaranteed to be resolved unless specifically addressed as part of the service.',
      '> By submitting your laptop for repair, you agree to the terms and conditions outlined in this\ndisclaimer.'
    ];
    return List.generate(
      heading.length,
          (index) {
        final topOffset = 1910.h + (50.h * index);
        return PositionedWidget(
          top: topOffset,
          left: 17.w,
          width: 350.w,
          height: 80.h,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: heading[index],fontWeight: FontWeight.w600,fontSize: 12.sp,),
              CustomText(text: answer[index],fontSize:7.sp ,fontWeight: FontWeight.w500,color: Color(0xff505050),
              )
            ],
          ),
        );
      },
    );
  }




}
