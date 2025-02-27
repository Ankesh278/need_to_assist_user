import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/utils/keyboard_utils.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';
class PaymentScreen extends StatefulWidget {
  final double totalCost;
  final String cartId;
  final String selectedDate; // Add selected date
  final String selectedTimeSlot; // Add selected time slot

  const PaymentScreen({
    super.key,
    required this.totalCost,

    required this.selectedDate,
    required this.selectedTimeSlot, required this.cartId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController numberController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController cvvController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double taxes = 50; // Define taxes amount
    double finalTotal = widget.totalCost + taxes;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        dismissKeyboard(context);
      },
      child: Scaffold(backgroundColor: ColorUtils.primary,
          body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(height: 918.h,
                  child: Stack(
                    children: [
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
                          top: 86.h,
                          left: 0.w,
                          width: 391.w,
                          height: 918.h,
                          child: Container(
                            decoration: BoxDecoration(color: ColorUtils.background,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.r),
                                    topRight: Radius.circular(30.r)),
                                boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1,
                                    offset: Offset(2, 0),
                                    spreadRadius: 1
                                )
                                ]
                            ),
                          )
                      ),
                      PositionedWidget(
                          top: 101.h,
                          left: 32.w,
                          width: 136.w,
                          height: 20.h,
                          child: CustomText(text: 'Payment summary',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,)
                      ),
                      PositionedWidget(
                        top: 141.h,
                        left: 32.w,
                        width: 322.w,
                        height: 119.h,
                        child: Container(
                            decoration: BoxDecoration(color: Color(0xffF9F9F9),
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                    spreadRadius: 1
                                )
                                ])
                        ),
                      ),
                      PositionedWidget(
                        top: 156.h,
                        left: 32.w,
                        width: 12.w,
                        height: 87.h,
                        child: Container(
                            decoration: BoxDecoration(color: Color(0xff404140),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(5.r)),
                            )
                        ),
                      ),
                      PositionedWidget(
                          top: 157.h,
                          left: 54.w,
                          width: 137.w,
                          height: 18.h,
                          child: CustomText(text: 'Charging/Power issue',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,)
                      ),
                      PositionedWidget(
                          top: 154.h,
                          left: 250.w,
                          width: 60.w,
                          height: 20.h,
                          child: CustomText(text: '₹ ${widget.totalCost.toStringAsFixed(0)}',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600)
                      ),
                      PositionedWidget(
                          top: 185.h,
                          left: 54.w,
                          width: 289.w,
                          height: 1.h,
                          child: Image.asset('assets/images/payment_screen/line.png')
                      ),
                      PositionedWidget(
                          top: 193.h,
                          left: 54.w,
                          width: 137.w,
                          height: 18.h,
                          child: CustomText(text: 'Taxes and Fee',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,)
                      ),
                      PositionedWidget(
                          top: 192.h,
                          left: 250.w,
                          width: 60.w,
                          height: 20.h,
                          child: CustomText(text: '₹ ${taxes.toStringAsFixed(0)}',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600)
                      ),
                      PositionedWidget(
                          top: 224.h,
                          left: 54.w,
                          width: 289.w,
                          height: 1.h,
                          child: Image.asset('assets/images/payment_screen/line.png')
                      ),
                      PositionedWidget(
                          top: 230.h,
                          left: 54.w,
                          width: 137.w,
                          height: 18.h,
                          child: CustomText(text: 'Total',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,)
                      ),
                      PositionedWidget(
                          top: 234.h,
                          left: 250.w,
                          width: 60.w,
                          height: 20.h,
                          child: CustomText(text: '₹ ${finalTotal.toStringAsFixed(0)}',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600)
                      ),
                     ..._buildPaymentOptions(),
                      PositionedWidget(top: 655.h, left: 17.w, width: 357.w, height: 162.h, child: Container(
                        decoration: BoxDecoration(color: Color(0xffF7F7F7),),
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomText(text: 'Card Number',fontWeight: FontWeight.w500,fontSize: 10.sp,color: Color(0xff777777),),
                              Container(width: 331.w,height: 32.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: ColorUtils.background),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    SizedBox(width:150.w,height: 22.h,
                                      child: TextField(controller:numberController,keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(hintText: 'xxxx xxxx xxxx xxxx',
                                            hintStyle: TextStyle(color: Color(0xff929091),fontWeight: FontWeight.w400,fontSize: 15.sp,),border: InputBorder.none),
                                      ),
                                    ),
                                      Image.asset('assets/images/payment_screen/6.png')
                                    ],),
                                ),),
                              Row(
                                children: [
                                CustomText(text: 'Valid Thru',fontWeight: FontWeight.w500,fontSize: 10.sp,color: Color(0xff777777),),
                                SizedBox(width: 130.w,),
                                CustomText(text: 'CVV',fontWeight: FontWeight.w500,fontSize: 10.sp,color: Color(0xff777777),),
                              ],),
                              Row(children: [
                                Container(width: 152.w,height: 32.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: ColorUtils.background),child:  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(controller:dateController,keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(hintText: '',
                                            hintStyle: TextStyle(color: Color(0xff929091),fontWeight: FontWeight.w400,fontSize: 15.sp,),border: InputBorder.none),
                                      ),
                                  ),
                                  ),
                                SizedBox(width: 25.w,),
                                Container(width: 152.w,height: 32.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: ColorUtils.background),child:  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(controller:cvvController,keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(hintText: '',
                                          hintStyle: TextStyle(color: Color(0xff929091),fontWeight: FontWeight.w400,fontSize: 15.sp,),border: InputBorder.none),
                                    ),
                                  ),
                                )
                              ],),
                              Center(
                                child: GestureDetector(
                                  onTap: () async{

   /* final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    List<Map<String, dynamic>> bookedServices = widget.quantities.entries.map((entry) {
    final service = serviceProvider.filteredServices[entry.key];
    return {
    'serviceName': service.name,
    'quantity': entry.value,
    'price': service.price,
    'totalPrice': service.price * entry.value,
    'timestamp': DateTime.now().toString(),
    };
    }).toList();

    // Save to SharedPreferences (or use Firebase Firestore for cloud storage)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> existingBookings = prefs.getStringList('booking_history') ?? [];
    existingBookings.add(jsonEncode(bookedServices));
    await prefs.setStringList('booking_history', existingBookings);

    // Navigate to Profile Screen (My Booking Section)
    Navigator.pushNamed(context, '/profile');
*/

                                      try {
                                        // Get Firebase User ID
                                        final user = FirebaseAuth.instance
                                            .currentUser;
                                        print("user info:${user}");
                                        if (user == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                "User not logged in")),
                                          );
                                          return;
                                        }
                                        String userId = user.uid;

                                        // Fetch User Location from Firestore
                                        DocumentSnapshot userDoc = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(userId)
                                            .get();

                                        if (!userDoc.exists ||
                                            userDoc.data() == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                "User location not found")),
                                          );
                                          return;
                                        }

                                        Map<String, dynamic> userData = userDoc
                                            .data() as Map<String, dynamic>;
                                        List<double> userLocation = [
                                          (userData['longitude'] as num)
                                              .toDouble(),
                                          (userData['latitude'] as num)
                                              .toDouble(),
                                        ];

                                        // Construct Payment Data
                                        Map<String, dynamic> paymentData = {
                                          "userId": FirebaseAuth.instance.currentUser!.uid,
                                          "cartId": widget.cartId,
                                          // Replace with actual cartId
                                          "paymentMethod": "Cash on Delivery",
                                          "userLocation": userLocation,
                                          "date": widget.selectedDate,
                                          "timeSlot": widget.selectedTimeSlot
                                        };
                                        print(paymentData);

                                        // Send Data to API
                                        final response = await http.post(
                                          Uri.parse(
                                              'http://15.207.112.43:8080/api/service/booking'),
                                          // Replace with actual API URL
                                          headers: {
                                            "Content-Type": "application/json"
                                          },
                                          body: jsonEncode(paymentData),
                                        );

                                        if (response.statusCode == 200) {

                                          print(response.body);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                "Payment successful")),
                                          );
                                           // Navigate to Profile Screen
                                        } else {
                                          print(response.body);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                "Payment failed: ${response
                                                    .body}")),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text("Error: $e")),
                                        );
                                      }


                                  },
                                  child: Container(width: 233.w,height: 28.h,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r),color: ColorUtils.primaryDark),child: Center(child: CustomText(text: 'Pay ₹ ${finalTotal.toStringAsFixed(0)}',color: ColorUtils.background))
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) ,
                      ))


                    ],
                  ),
                ),
              ))
      ),
    );
  }

  List<Widget> _buildPaymentOptions() {
    final options = [
      'Add new UPI ID',
      'Google Pay',
      'Paytm UPI',
      'Credit/Debit Card',
      'Cash',
    ];
    final images = [
      '1.png',
      '2.png',
      '3.png',
      '4.png',
      '5.png',
    ];
    return List.generate(
      options.length,
          (index) {
        final topOffset = 291.h + (69.h * index);
        return PositionedWidget(
          top: topOffset,
          left: 17.w,
          width: 357.w,
          height: 55.h,
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
            child: ListTile(
              leading: SizedBox(
                width: 53.w,
                height: 31.h,
                child: Image.asset(
                  'assets/images/payment_screen/${images[index]}',
                ),
              ),
              title: CustomText(
                text: options[index],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              trailing: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: const Color(0xffD9D9D9),
                ),

              ),
            ),
          ),
        );
      },
    );
  }
}