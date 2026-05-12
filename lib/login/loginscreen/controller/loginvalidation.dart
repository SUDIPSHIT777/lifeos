import 'package:flutter/material.dart';
import 'package:lifeos/core/utils/snackbar.dart';

class Loginvalidation {
  static String? emailValidator(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? passwordValidator(TextEditingController controller) {
    final value = controller.text;

    if (value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}
