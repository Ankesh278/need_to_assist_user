import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';
import '../../providers/navigation_provider.dart';
import '../widgets/custom_position_widget.dart';
import '../widgets/custom_text_widget.dart';

class MapSample extends StatelessWidget {
  const MapSample({super.key});

  @override
  Widget build(BuildContext context) {
    print('hello');
    return Scaffold(
      body:
      SafeArea(
          child: Stack(
            children: [
              Consumer<MapProvider>(
                builder: (context, mapProvider, child) {
                  return PositionedWidget(
                    top: 0.h,
                    left: 0.w,
                    width: 393.w,
                    height: 758.h,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: mapProvider.currentPosition,
                        zoom: 14.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        mapProvider.setMapController(controller);
                      },
                    ),
                  );
                },
              ),
              PositionedWidget(top: 564.h,left: 0,width: 390.w,height: 280.h,
                  child:Container(
                    decoration: BoxDecoration(color:Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),topRight: Radius.circular(20.r))),) ),
              PositionedWidget(top: 636.h, left: 74.w, width:242.w, height: 18.h, child: CustomText(text: 'Where do you want your service?',fontWeight:FontWeight.w600 ,fontSize: 15.sp,)),

              // "At My Current Location" Button (Only rebuilds if location updates)
              Consumer<MapProvider>(
                builder: (context, mapProvider, child) {
                  return PositionedWidget(
                    top: 682.h,
                    left: 12.w,
                    width: 366.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        mapProvider.getUserLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff5A5A5A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: CustomText(
                        text: mapProvider.locationFetched
                            ? 'Location Updated'
                            : 'At my current location',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
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
