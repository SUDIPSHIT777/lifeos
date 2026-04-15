import 'package:flutter/material.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/login/signupscreen/controller/signupcontroller.dart';

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

  //===================All Validation=====================
  static void validation(
    BuildContext context,
    GlobalKey<FormState> formKey,
    Signupcontroller controller,
  ) {
    if (!controller.ischeck.value) {
      return Snackbardesign.showCustomSnackbar(
        title: "Error",
        subtitle: "Please accept Terms & Conditions",
        backgroundColor: Color(0xFFFF9800),
        icon: Icons.error,
      );
    }
    if (formKey.currentState!.validate()) {
      return Snackbardesign.showCustomSnackbar(
        title: "Welcome To Lifeos Manage Your Task With Ai",
        subtitle: "Signup successful",
        backgroundColor: Color(0xFF00c247),
        icon: Icons.auto_awesome,
      );
    } else {
      return Snackbardesign.showCustomSnackbar(
        title: "Something went wrong",
        subtitle: "Signup Failed",
        backgroundColor: Color(0xFFFF9800),
        icon: Icons.auto_awesome,
      );
    }
  }
}
