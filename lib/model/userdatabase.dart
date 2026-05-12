import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeos/model/usermodel.dart';

class Userdatabase {
  Future<Usermodel?> getuserdata() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return null;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return Usermodel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception("Get user data error: $e");
    }
  }
}
