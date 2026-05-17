import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/model/usermodel.dart';

class Signupprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signup({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      //================ CREATE AUTH USER =================

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);

      Usermodel usermodel = Usermodel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(usermodel.uid)
          .set(usermodel.toMap());

      Snackbardesign.showCustomSnackbar(
        title: "Sign Up",
        subtitle: "Signup Successful",
        backgroundColor: const Color(0xFF00c247),
        icon: Icons.done_outline_outlined,
      );
    } on FirebaseAuthException catch (e) {
      Snackbardesign.showCustomSnackbar(
        title: "Sign Up",
        subtitle: e.message ?? "Signup Failed",
        backgroundColor: const Color(0xFFFF9800),
        icon: Icons.error_outline_outlined,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  bool _isChecked = false;
  bool get isChecked => _isChecked;

  void toggleCheckbox(bool value) {
    _isChecked = value;
    notifyListeners();
  }
}
