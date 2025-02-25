import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<List<Map<String, dynamic>>> bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _loadBookingHistory();
  }

  Future<void> _loadBookingHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedBookings = prefs.getStringList('booking_history') ?? [];

    setState(() {
      bookingHistory = storedBookings.map((e) => List<Map<String, dynamic>>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> _deleteBooking(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove booking from the list
    setState(() {
      bookingHistory.removeAt(index);
    });

    // Save updated list to SharedPreferences
    List<String> updatedBookings = bookingHistory.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('booking_history', updatedBookings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Bookings")),
      body: bookingHistory.isEmpty
          ? Center(child: Text("No booking history available."))
          : ListView.builder(
        itemCount: bookingHistory.length,
        itemBuilder: (context, index) {
          final booking = bookingHistory[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...booking.map((service) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Service: ${service['serviceName']}", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Quantity: ${service['quantity']}"),
                        Text("Price: ₹${service['price']}"),
                        Text("Total: ₹${service['totalPrice']}"),
                        Text("Booked On: ${service['timestamp']}"),
                        Divider(),
                      ],
                    );
                  }).toList(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text("Delete", style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        _deleteBooking(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
