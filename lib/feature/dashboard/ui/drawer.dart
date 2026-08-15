import 'package:flutter/material.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/login/googleauth/googleauth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const SizedBox(height: 10),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff5B5FEF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<Userprovider>(
                  builder: (context, user, child) => Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF000000).withValues(alpha: 0.2),
                  ),
                  child: const Center(
                    child: Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Consumer<Userprovider>(
              builder: (context, user, child) => Text(
                user.email,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff5B5FEF).withValues(alpha: .12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "PREMIUM PLAN",
                style: TextStyle(
                  color: Color(0xff5B5FEF),
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Consumer<GoogleAuth>(
                builder: (context, value, child) {
                  return Container(
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => value.logout(),
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withValues(alpha: 0.05),
                        highlightColor: Colors.red.withValues(alpha: 0.03),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              // Logout Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade50,
                                      Colors.red.shade100,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red.shade600,
                                  size: 23,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Text
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E1E1E),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Sign out from your account",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A8A8A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Arrow
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
