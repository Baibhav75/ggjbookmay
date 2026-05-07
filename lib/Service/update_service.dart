import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UpdateService {
  static String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
  }

  // 🔔 Setup FCM Listener for Foreground Updates
  static void setupFCMUpdateListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      final isUpdate = data['type'] == 'update' || 
          (message.notification?.title?.toLowerCase().contains('update') ?? false);
          
      if (isUpdate) {
        final url = data['url'] ?? "https://baibhav75.github.io/Portfolio/";
        _showDialogSafe(context, url, data: data);
      }
    });
  }

  static Future<void> checkForUpdate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 🔴 1. Check: user already updated?
    bool isUpdated = prefs.getBool("is_app_updated") ?? false;

    if (isUpdated) {
      print("User already updated app");
      return; // ❌ popup kabhi nahi dikhega
    }

    // 📅 2. Daily check
    String today = DateTime.now().toIso8601String().split('T')[0];
    String? lastShownDate = prefs.getString("last_update_popup_date");

    if (lastShownDate == today) {
      print("Already shown today");
      return;
    }

    // ✅ Save today
    await prefs.setString("last_update_popup_date", today);

    _showDialogSafe(context, "https://baibhav75.github.io/Portfolio/");
  }

  // Safe dialog
  static void _showDialogSafe(BuildContext context, String url, {Map<String, dynamic>? data}) {
    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showUpdateDialog(context, url, data: data);
    });
  }

  static void showUpdateDialog(BuildContext context, String url, {Map<String, dynamic>? data}) {
    String todayDate = getFormattedDate(); // 📅 get date
    
    // Extract custom content if provided via FCM data
    String title = data?['title'] ?? "Update Available 🚀";
    String desc = data?['description'] ?? "Date: $todayDate\n\nA new and improved version of the app is available! Update now to experience new features and better performance.";
    String imageUrl = data?['imageUrl'] ?? 'https://img.freepik.com/free-vector/app-update-concept-illustration_114360-7389.jpg';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Compact height
            children: <Widget>[
              // 🖼️ Top Image Banner (Flipkart Style)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160,
                      color: Colors.deepPurple.shade50,
                      child: const Icon(Icons.system_update_alt, size: 60, color: Colors.deepPurple),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              
              // 📌 Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              
              // 📝 Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 28.0),
              
              // 🔘 Action Buttons
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          "Later",
                          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          // Mark updated so popup won't show again normally
                          await prefs.setBool("is_app_updated", true);

                          final uri = Uri.parse(url);
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                          
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B46C1), // Match theme deep purple
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Update Now",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}