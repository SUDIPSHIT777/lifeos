import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/model/userdatabase.dart';
import 'package:lifeos/model/usermodel.dart';

class GoogleAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool isSigningIn = false;
  Future<User?> signInWithGoogle() async {
    if (isSigningIn) return null;
    isSigningIn = true;
    notifyListeners();
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        await _googleSignIn.initialize();
        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      log("Google SignIn Error: $e");
      return null;
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      await _auth.authStateChanges().first;
      notifyListeners();
      Snackbardesign.showCustomSnackbar(
        title: "Logout",
        subtitle: "Logged out successfully",
        backgroundColor: const Color(0xFFFF9800),
        icon: Icons.logout,
      );
    } catch (e) {
      throw Exception("Logout Error: $e");
    }
  }

  Future<void> googlesigncheck(BuildContext context) async {
    final user = await signInWithGoogle();
    if (user != null) {
      final usermodel = Usermodel(
        uid: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
      );
      Snackbardesign.showCustomSnackbar(
        title: "Login Successfully",
        subtitle: "Welcome to Lifeos",
        backgroundColor: const Color(0xFF00c247),
        icon: Icons.download_done_outlined,
      );
      await Userdatabase().saveuserinfo(usermodel);
    }
    if (user == null) {
      Snackbardesign.showCustomSnackbar(
        title: "Login Failed",
        subtitle: "No User Found Try Again",
        backgroundColor: const Color(0xFFFF9800),
        icon: Icons.error_outline,
      );
    }
  }
}
