import 'package:flutter/material.dart';

class SignupValidators {
  //===================Email Validation=====================
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

  //===================Password Validation=====================
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

  //===================Name Validation=====================
  static String? nameValidator(TextEditingController name) {
    final namecontroller = name.text;
    if (namecontroller.isEmpty) {
      return "Name is required";
    }
    if (namecontroller.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

}
