import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/widgets/custom_text_formfield.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/location_provider.dart';
import '../widgets/custom_text_widget.dart';
import 'home_screen.dart';

class LocationSearch extends StatefulWidget {
  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = "12345";
  List<dynamic> _placesList = [];
  String _selectedAddress = "";
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == "12345") {
      _sessionToken = uuid.v4();
    }
    getSuggestions(_searchController.text);
  }

  void getSuggestions(String query) async {
    String apiKey = "AIzaSyBUmPinXCwWmhK3SvG4AAAsQfpayru3qKE";
    String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = "$baseUrl?input=$query&key=$apiKey&sessiontoken=$_sessionToken";

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  void getPlaceDetails(String placeId) async {
    String apiKey = "AIzaSyBUmPinXCwWmhK3SvG4AAAsQfpayru3qKE";
    String detailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    var response = await http.get(Uri.parse(detailsUrl));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)['result'];
      var location = result['geometry']['location'];

      setState(() {
        _selectedAddress = result['formatted_address'];
        _selectedPosition = LatLng(location['lat'], location['lng']);
      });
    } else {
      throw Exception("Failed to fetch location details");
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorUtils.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFormField(controller: _searchController, labelText: "Search for your location",
                  hintText: 'Enter the location',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your valid location';
                }
                return null;
              },
            ),),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_placesList[index]['description']),
                    onTap: () {
                      _searchController.text = _placesList[index]['description'];
                      getPlaceDetails(_placesList[index]['place_id']);
                    },
                  );
                },
              ),
            ),
            if (_selectedAddress.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Selected: $_selectedAddress"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedPosition != null) { // Replace with actual user ID from Firebase Auth
                    locationProvider.updateLocation(
                        _selectedPosition!, _selectedAddress);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );


                  }
                },style: ElevatedButton.styleFrom(backgroundColor: Color(0xff5A5A5A),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: CustomText(
                  text: 'Continue',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
