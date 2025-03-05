import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RepairProcess {
  final String title;
  final String description;

  RepairProcess({
    required this.title,
    required this.description,
  });

  factory RepairProcess.fromJson(Map<String, dynamic> json) {
    return RepairProcess(
      title: json["title"] ?? "No Title",
      description: json["description"] ?? "No Description",
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({
    required this.question,
    required this.answer,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json["question"] ?? "No Question",
      answer: json["answer"] ?? "No Answer",
    );
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryName;
  final String image;
  final String time;
  final String warranty;
  final String systemType;
  final List<RepairProcess> repairProcesses;
  final List<FAQ> faqs;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryName,
    required this.image,
    required this.time,
    required this.warranty,
    required this.systemType,
    required this.repairProcesses,
    required this.faqs,
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
      time: json["time"] ?? "N/A",
      warranty: json["warranty"] ?? "No Warranty",
      systemType: json["systemType"] ?? "Unknown",
      repairProcesses: (json["repairProcesses"] as List<dynamic>?)
          ?.map((item) => RepairProcess.fromJson(item))
          .toList() ??
          [],
      faqs: (json["faqs"] as List<dynamic>?)
          ?.map((item) => FAQ.fromJson(item))
          .toList() ??
          [],
    );
  }
}


class ServiceProvider with ChangeNotifier {
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];

  List<Service> get filteredServices => _filteredServices;

  Future<void> fetchServices() async {
    final url = Uri.parse("http://15.207.112.43:8080/api/product/getproduct/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null || !data.containsKey("products") || data["products"] == null) {
          print("Error: 'products' key is missing or empty in API response.");
          return;
        }

        final List<dynamic> productsList = data["products"];
        _allServices = productsList.map((item) => Service.fromJson(item)).toList();
        _filteredServices = List.from(_allServices);

        // Save data locally
        await saveDataLocally(productsList);

        notifyListeners();
      } else {
        throw Exception("Failed to load services. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching services: $error");

      // Load data from local storage if an error occurs
      await loadLocalData();
    }
  }

  Future<void> saveDataLocally(List<dynamic> productsList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cached_services", jsonEncode(productsList));
  }

  Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString("cached_services");

    if (cachedData != null) {
      final List<dynamic> productsList = jsonDecode(cachedData);
      _allServices = productsList.map((item) => Service.fromJson(item)).toList();
      _filteredServices = List.from(_allServices);
      notifyListeners();
    } else {
      print("No cached data available.");
    }
  }

  void filterServicesByCategory(String categoryName) {
    _filteredServices = _allServices.where((service) => service.categoryName == categoryName).toList();
    notifyListeners();
  }
  void resetFilter() {
    _filteredServices = _allServices; // Reset to original list
    notifyListeners();
  }
}

