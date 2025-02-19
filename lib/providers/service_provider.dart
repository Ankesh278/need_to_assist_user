import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryName;
  final String image;
  final String time; // Added time field

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryName,
    required this.image,
    required this.time, // Initialize time
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    const String baseUrl = "http://15.207.112.43:8080/";

    return Service(
      id: json["_id"] ?? "",
      name: json["name"] ?? "No Name",
      description: json["description"] ?? "No Description",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      categoryName: json["categoryName"] ?? "Unknown",
      image: json["image"].startsWith("http")
          ? json["image"]
          : "$baseUrl${json["image"]}".replaceAll("\\", "/"),
      time: json["time"] ?? "N/A", // Fetch time from API
    );
  }
}


class ServiceProvider with ChangeNotifier {
  List<Service> _allServices = []; // Store all services
  List<Service> _filteredServices = []; // Filtered list

  List<Service> get filteredServices => _filteredServices;

  Future<void> fetchServices() async {
    final url = Uri.parse("http://15.207.112.43:8080/api/product/getproduct/");

    try {
      final response = await http.get(url);
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null || !data.containsKey("products") || data["products"] == null) {
          print("Error: 'products' key is missing or empty in API response.");
          return;
        }

        final List<dynamic> productsList = data["products"];

        _allServices = productsList.map((item) => Service.fromJson(item)).toList();
        _filteredServices = List.from(_allServices); // Initially show all
        notifyListeners();
      } else {
        throw Exception("Failed to load services. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching services: $error");
    }
  }

  void filterServicesByCategory(String categoryName) {
    _filteredServices = _allServices.where((service) => service.categoryName == categoryName).toList();
    notifyListeners();
  }
}
