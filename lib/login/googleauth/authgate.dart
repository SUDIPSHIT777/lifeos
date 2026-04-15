import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/core/utils/navigationbar.dart';
import 'package:lifeos/feature/splashscreen/splashprovider.dart';
import 'package:lifeos/feature/splashscreen/splashscreen.dart';
import 'package:lifeos/login/loginscreen/ui/loginscreen.dart';
import 'package:provider/provider.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, value, child) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!value.isDone) {
            return const Splashscreen();
          }
          if (snapshot.hasData) {
            return const Navigationbar();
          }
          return const Loginscreen();
        },
      ),
    );
  }
}
