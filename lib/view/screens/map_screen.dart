import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/location_provider.dart';
import '../../providers/navigation_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class MapSample extends StatefulWidget {

  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  GoogleMapController?  _mapController;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).loadSavedLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: ColorUtils.background,
      body:
      SafeArea(
          child: Stack(
            children: [
               PositionedWidget(
                    top: 0.h,
                    left: 0.w,
                    width: 393.w,
                    height: 758.h,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: locationProvider.currentPosition ?? LatLng(28.6161, 77.1014), // Default to SF
                        zoom: 16.0,
                      ),
                      myLocationEnabled: true,
                      markers: locationProvider.marker != null
                          ? {locationProvider.marker!}
                          : {},
                      onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      Provider.of<LocationProvider>(context, listen: false).setMapController(controller);
                    },

                    ),
              ),
              PositionedWidget(top: 564.h,left: 0,width: 390.w,height: 280.h,
                  child:Container(
                    decoration: BoxDecoration(color:Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),topRight: Radius.circular(20.r))),) ),
              PositionedWidget(top: 636.h, left: 74.w, width:242.w, height: 18.h, child: CustomText(text: 'Where do you want your service?',fontWeight:FontWeight.w600 ,fontSize: 15.sp,)),

              // "At My Current Location" Button (Only rebuilds if location updates)
              PositionedWidget(
                top: 682.h,
                left: 12.w,
                width: 366.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async{
                    await locationProvider.getCurrentLocation(context);
                    if (locationProvider.currentPosition != null) {
                      _mapController?.animateCamera(CameraUpdate.newLatLng(
                          locationProvider.currentPosition!));
                    }
                      Provider.of<NavigationProvider>(context, listen: false).navigateTo('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff5A5A5A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: CustomText(
                    text: 'Get Current Location',
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              PositionedWidget(top: 745.h, left: 12.w, width: 366.w, height: 50.h, child: ElevatedButton(
                  onPressed: (){
                    Provider.of<NavigationProvider>(context, listen: false).navigateTo(
                      '/location_search',
                    );

                  },style:ElevatedButton.styleFrom(backgroundColor:Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  child:CustomText(text: 'I’ll enter my location manually',fontWeight: FontWeight.w700,fontSize: 15.sp,color: Colors.black,)))
            ],
          )),
    );
  }
}
