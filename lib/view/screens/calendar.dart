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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 10,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorUtils.primaryDark, ColorUtils.primaryDark,],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Decorative Calendar Badge
                      Container(
                        width: 70,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Month part (dynamic)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Center(
                                child: Text(
                                  DateFormat('MMM').format(selectedDate ?? DateTime.now()).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Day part (dynamic)
                            Text(
                              (selectedDate ?? DateTime.now()).day.toString(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            // Year part (dynamic)
                            Text(
                              (selectedDate ?? DateTime.now()).year.toString(),
                              style: const TextStyle(fontSize: 12, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Right-side date text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Selected Date",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              selectedDate == null
                                  ? "📅 Tap to Select Date"
                                  : "📆 ${DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 5)]
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
