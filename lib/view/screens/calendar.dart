import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:need_to_assist/core/constants/app_colors.dart';
import 'package:need_to_assist/view/screens/payment_screen.dart';

class ChooseSlotScreen extends StatefulWidget {
  final double totalCost;
  final String cartId;

  const ChooseSlotScreen({super.key, required this.totalCost, required this.cartId});

  @override
  State<ChooseSlotScreen> createState() => _ChooseSlotScreenState();
}

class _ChooseSlotScreenState extends State<ChooseSlotScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    "09:00 - 11:00",
    "11:00 - 13:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
    "17:00 - 19:00"
  ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 4)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black, // Header color & selected date highlight
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Selected date and button color
              onPrimary: Colors.white, // Text color on selected date
              onSurface: Colors.black, // Default text color
            ),
            dialogBackgroundColor: Colors.white, // Background color
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorUtils.background,
      appBar: AppBar(
        title: const Text("Choose Date & Time"),
        backgroundColor: ColorUtils.background,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  selectedDate == null
                      ? "Select Date"
                      : "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.black),
                onTap: () => _selectDate(context),
              ),
            ),

            const SizedBox(height: 20),

            // Time Slot Picker
            const Text("Select Time Slot:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((slot) {
                bool isSelected = selectedTimeSlot == slot;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeSlot = slot;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)]
                          : [],
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // Proceed Button
            SizedBox(
              width: screenWidth,
              child: ElevatedButton(
                onPressed: (selectedDate != null && selectedTimeSlot != null)
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        totalCost: widget.totalCost,
                        selectedDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
                        cartId: widget.cartId,
                        selectedTimeSlot: selectedTimeSlot!,
                      ),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Proceed to Payment",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
