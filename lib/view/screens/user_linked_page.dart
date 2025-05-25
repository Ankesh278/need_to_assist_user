import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/navigation_provider.dart';
class NeoUserProfilePage extends StatefulWidget {

   const NeoUserProfilePage({super.key});

  @override
  State<NeoUserProfilePage> createState() => _NeoUserProfilePageState();
}

class _NeoUserProfilePageState extends State<NeoUserProfilePage> {
  Map<String, dynamic>? userData;
  UserModel? user;
  final RxString selectedReason = "".obs;
  final RxBool showError = false.obs;
  String? uid;
  @override
  void initState() {
    super.initState();
    loadUserDataFromHive();
    loadUid();
  }
  Future<void> loadUid() async {
    final box = Hive.isBoxOpen('tokenBox') ? Hive.box('tokenBox') : await Hive.openBox('tokenBox');
    uid = box.get('uid');
    print("UID from Hive: $uid");
    setState(() {});
  }

  Future<void> loadUserDataFromHive() async {
    var box = Hive.isBoxOpen('userBox') ? Hive.box<UserModel>('userBox') : await Hive.openBox<UserModel>('userBox');
    user = box.get('userBox');
    if (user != null) {
      if (kDebugMode) {
        print('Name: ${user!.name ?? 'null'}');
        print('Address: ${user!.address ?? 'null'}');
        print('Phone: ${user!.phoneNumber ?? 'null'}');
        print('Email: ${user!.email ?? 'null'}');
        print('Other data in user: ${user?.toMap()}');
      }
    } else {
      // Print if user is null
      if (kDebugMode) {
        print('User data is null');
      }
    }

    // Retrieve uid and token from Hive
    final uid = box.get('uid');
    final token = box.get('token');

    // Print the uid and token (or 'null' if they don't exist)
    if (kDebugMode) {
      print('UID: ${uid ?? 'null'}');
      print('Token: ${token ?? 'null'}');
    }

    setState(() {
      // Set the userData map with retrieved values
      userData = {
        'uid': uid ?? 'Unknown',
        'token': token ?? 'Unknown',
      };
    });
  }


  Future<bool> deleteUserAccount(String userId, String reason) async {
    const String api = 'https://needtoassist.com/api/user/deleteacc';
    final url = Uri.parse(api);
    if (kDebugMode) {
      print("API URL: $api");
    }

    final Map<String, dynamic> requestBody = {
      'uid': userId,
      'reason': reason,
    };

    if (kDebugMode) {
      print("Request Body: ${jsonEncode(requestBody)}");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print("Response Decoded: $data");
        }

        if (data['message'] == 'User account deleted successfully') {
          await Hive.close();
          await Hive.deleteFromDisk();
          return true;
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting account: $e");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [Colors.white, Colors.deepPurple.shade100]),
                    ),
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(""),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _glassCard(context, [
                  // _infoTile(Icons.person_outline, "Name", user!.name),
                  // _infoTile(Icons.home_outlined, "Address", user!.address),
                  // _infoTile(Icons.phone_outlined, "Phone", user!.phoneNumber),
                  // _infoTile(Icons.mail_outline, "Email", user!.email),
                  _infoTile(Icons.person_outline, "Name", user?.name ?? '---'),
                  _infoTile(Icons.home_outlined, "Address", user?.address ?? '---'),
                  _infoTile(Icons.phone_outlined, "Phone", user?.phoneNumber ?? '---'),
                  _infoTile(Icons.mail_outline, "Email", user?.email ?? '---'),

                ]),
                SizedBox(height: 100),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: Icon(Icons.delete_forever_rounded,color: Colors.white,),
                label: Text("Delete Account",style: TextStyle(color: Colors.white),),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassCard(BuildContext context, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.shade50,
        child: Icon(icon, color: Colors.black54),
      ),
      title: Text(title, style: TextStyle(color: Colors.grey.shade700)),
      subtitle: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        titlePadding: EdgeInsets.only(top: 16),
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.shade50,
              radius: 30,
              child: Icon(Icons.warning_amber_rounded, size: 36, color: Colors.redAccent),
            ),
            SizedBox(height: 16),
            Text(
              "Are You Sure?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Deleting your account is permanent and cannot be undone.\n\nAll your data will be lost!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.delete_outline,color: Colors.black54,),
            label: Text("Yes, Delete"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black54,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showReasonSheet(context);
            },
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.green,
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showReasonSheet(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    final List<String> reasons = [
      "Privacy concerns",
      "Too many notifications",
      "Creating a new account",
      "Not satisfied with the app",
      "Other"
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.shade50,
                        ),
                        child: Icon(Icons.feedback_outlined, size: 32, color: Colors.black54),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Why are you leaving?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Let us know how we can improve",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ...reasons.map((reason) {
                  return InkWell(
                    onTap: () {
                      selectedReason.value = reason;
                      showError.value = false;
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedReason.value == reason
                            ? Colors.black54
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedReason.value == reason
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 2,
                              ),
                              color: selectedReason.value == reason
                                  ? Colors.deepPurple.shade300
                                  : Colors.transparent,
                            ),
                            child: selectedReason.value == reason
                                ? Icon(Icons.check, color: Colors.white, size: 14)
                                : null,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reason,
                              style: TextStyle(fontSize: 13.5,color: selectedReason.value == reason ? Colors.white : Colors.black87,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                if (selectedReason.value == "Other") ...[
                  SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Please write your reason",
                      hintStyle: TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      errorText: showError.value && reasonController.text.trim().isEmpty
                          ? 'This field is required'
                          : null,
                    ),
                  ),
                ],
                SizedBox(height: 24),
                Consumer<NavigationProvider>(
                  builder: (context, navigationProvider, child) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                      onPressed: () async {
                        if (selectedReason.value.isEmpty) {
                          showError.value = true;
                          return;
                        }
                        if (selectedReason.value == "Other" && reasonController.text.trim().isEmpty) {
                          showError.value = true;
                          return;
                        }
                        String finalReason = selectedReason.value == "Other"
                            ? reasonController.text.trim()
                            : selectedReason.value;
                        bool isDeleted = await deleteUserAccount(uid!,selectedReason.value);
                        if (isDeleted) {
                          Get.snackbar(
                            "Account Deleted",
                            "Reason: $finalReason",
                            backgroundColor: Colors.black54,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 4),
                          );
                          navigationProvider.navigateAndRemoveUntil('/login');
                        } else {
                          Get.snackbar(
                            "Error",
                            "Failed to delete the account. Please try again.",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 4),
                          );
                        }
                      },
                      icon: Icon(Icons.delete_forever, color: Colors.white),
                      label: Text("Submit & Delete", style: TextStyle(fontSize: 14.5)),
                    );
                  },
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
