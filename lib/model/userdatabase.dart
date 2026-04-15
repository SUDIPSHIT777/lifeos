import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeos/model/usermodel.dart';

class Userdatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveuserinfo(Usermodel user) async {
    final doc = _firestore.collection('users').doc(user.uid);
    final userdoc = await doc.get();
    if (!userdoc.exists) {
      await doc.set(user.toMap());
    }
  }

  Future<Usermodel?> getuserdata() async {
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return Usermodel.fromMap(data);
    }
    return null;
  }
}
