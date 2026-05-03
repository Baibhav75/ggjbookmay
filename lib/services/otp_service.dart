import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;

class OtpService {
  static String? _verificationId;

  /// Sends OTP to the provided phone number (+91 prefixed)
  static Future<void> sendOtp({
    required String phone,
    required Function(String message) onError,
    required Function() onCodeSent,
    required Function() onAutoVerified,
  }) async {
    try {
      dev.log("Attempting to send OTP to: +91$phone");

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        timeout: const Duration(seconds: 60),

        // ✅ Auto verify (instant login case)
        verificationCompleted: (PhoneAuthCredential credential) async {
          dev.log("OTP Auto Verified");
          await FirebaseAuth.instance.signInWithCredential(credential);
          onAutoVerified();
        },

        // ❌ Error case
        verificationFailed: (FirebaseAuthException e) {
          dev.log("OTP Verification Failed: ${e.message}");
          onError(e.message ?? "OTP Failed. Please check if Firebase is configured correctly.");
        },

        // 📩 OTP sent
        codeSent: (String verId, int? resendToken) {
          dev.log("OTP Sent Successfully. Verification ID: $verId");
          _verificationId = verId;
          onCodeSent();
        },

        // ⏱ Timeout
        codeAutoRetrievalTimeout: (String verId) {
          dev.log("OTP Code Auto Retrieval Timeout");
          _verificationId = verId;
        },
      );
    } catch (e) {
      dev.log("Exception in sendOtp: $e");
      onError("Something went wrong. Please try again.");
    }
  }

  /// Verifies the entered OTP code
  static Future<bool> verifyOtp(String otp) async {
    try {
      if (_verificationId == null) {
        dev.log("Verification ID is null. OTP cannot be verified.");
        return false;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      dev.log("OTP Verified and Signed In");
      return true;
    } catch (e) {
      dev.log("OTP Verification Failed: $e");
      return false;
    }
  }
}