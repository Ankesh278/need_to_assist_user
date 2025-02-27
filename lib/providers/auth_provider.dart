import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location_provider.dart';


  class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isResendEnabled = false; // ✅ Track OTP Resend State
  TextEditingController phoneController=TextEditingController();
  bool get isLoggedIn => _auth.currentUser != null;

  bool get isResendEnabled => _isResendEnabled;
  Future<void> logoutUser(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();


    // ✅ Clear saved location when logging out
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("saved_address");
    await prefs.remove("saved_lat");
    await prefs.remove("saved_lng");

    // ✅ Reset location data in LocationProvider
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.clearLocation();

    // Navigate to login screen
    Navigator.pushReplacementNamed(context, "/login");
  }

  User? _user;
  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Update UI whenever auth state changes
    });
  }


  Future<void> sendOTP(
      String phoneNumber, {
        required BuildContext context,
        Function(String)? onCodeSent,
        Function(String)? onError,
      }) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      onError?.call("Invalid phone number");
      return;
    }

    final formattedNumber = phoneNumber.startsWith("+91") ? phoneNumber : "+91$phoneNumber";

    try {
      // Show a snackbar when reCAPTCHA starts
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading reCAPTCHA, please wait...')),
      );

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Verification failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
          onError?.call(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _isResendEnabled = false; // ✅ Disable Resend Initially
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP Sent Successfully!')),
          );

          onCodeSent?.call(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _isResendEnabled = true; // ✅ Enable Resend After Timeout
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending OTP, please try again.')),
      );
      onError?.call("Error sending OTP");
    }
  }

  Future<bool> verifyOTP(String otp, {Function(String)? onError}) async {
  if (_verificationId == null) {
  onError?.call("Verification ID is null. Please request OTP again.");
  return false;
  }

  try {
  final credential = PhoneAuthProvider.credential(
  verificationId: _verificationId!,
  smsCode: otp,
  );

  await _auth.signInWithCredential(credential);
  return true; // ✅ OTP verified successfully
  } on FirebaseAuthException catch (e) {
  debugPrint('Firebase Error: ${e.message}');
  onError?.call(e.message ?? "OTP verification failed");
  return false;
  } catch (e) {
  debugPrint('Unknown error verifying OTP: $e');
  onError?.call("Unknown error verifying OTP");
  return false;
  }
  }
  }
