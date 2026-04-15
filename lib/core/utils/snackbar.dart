import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbardesign {
  static void showCustomSnackbar({
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Get.snackbar(" "," ",
      titleText: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),

      messageText: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      borderRadius: 16,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      backgroundGradient: LinearGradient(
        colors: [backgroundColor, backgroundColor.withValues(alpha: 0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      colorText: Colors.white,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.7),
          blurRadius: 25,
          spreadRadius: 3,
          offset: const Offset(0, 0),
        ),
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.4),
          blurRadius: 40,
          spreadRadius: 6,
          offset: const Offset(0, 0),
        ),
      ],
      borderWidth: 1,
      borderColor: backgroundColor,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
