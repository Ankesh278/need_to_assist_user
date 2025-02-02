import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

  class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  bool _isResendEnabled = false; // ✅ Track OTP Resend State
  TextEditingController phoneController=TextEditingController();

  bool get isResendEnabled => _isResendEnabled;

  Future<void> sendOTP(String phoneNumber, {Function(String)? onCodeSent, Function(String)? onError}) async {
  if (phoneNumber.isEmpty || phoneNumber.length < 10) {
  onError?.call("Invalid phone number");
  return;
  }

  final formattedNumber = phoneNumber.startsWith("+91") ? phoneNumber : "+91$phoneNumber";

  try {
  await _auth.verifyPhoneNumber(
  phoneNumber: formattedNumber,
  verificationCompleted: (PhoneAuthCredential credential) async {
  await _auth.signInWithCredential(credential);
  notifyListeners();
  },
  verificationFailed: (FirebaseAuthException e) {
  debugPrint('Verification failed: ${e.message}');
  onError?.call(e.message ?? "Verification failed");
  },
  codeSent: (String verificationId, int? resendToken) {
  _verificationId = verificationId;
  _isResendEnabled = false; // ✅ Disable Resend Initially
  notifyListeners();
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
