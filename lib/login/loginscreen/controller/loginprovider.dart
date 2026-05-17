import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/model/usermodel.dart';

class Loginprovider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //================ Login =================
  Usermodel? _currentUser;
  Usermodel? get currentUser => _currentUser;
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      _currentUser = Usermodel.fromMap(doc.data()!);
      Snackbardesign.showCustomSnackbar(
        title: "Login",
        subtitle: "Login Successful",
        backgroundColor: const Color(0xFF00c247),
        icon: Icons.done_outline_outlined,
      );
    } on FirebaseAuthException catch (e) {
      Snackbardesign.showCustomSnackbar(
        title: "Login",
        subtitle: e.message ?? "Login Failed",
        backgroundColor: const Color(0xFFFF9800),
        icon: Icons.error_outline_outlined,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
