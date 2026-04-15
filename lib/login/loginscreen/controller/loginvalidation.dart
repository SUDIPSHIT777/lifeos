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

  static void validation(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      return Snackbardesign.showCustomSnackbar(
        title: "Welcome To Lifeos Manage Your Task With Ai",
        subtitle: "Login Successfully",
        backgroundColor: Color(0xFF00c247),
        icon: Icons.auto_awesome,
      );
    } else {
      return Snackbardesign.showCustomSnackbar(
        title: "There IS Somthing is Wrong",
        subtitle: "Login Failed",
        backgroundColor: Color(0xFFFF9800),
        icon: Icons.auto_awesome,
      );
    }
  }

  static String? nameValidator(TextEditingController name) {
    final namecontroller = name.text;
    if (namecontroller.isEmpty) {
      return "Name is required";
    }
    if (namecontroller.length < 6) {
      return "Name must be at least 3 characters";
    }
    return null;
  }
}
