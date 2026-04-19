import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/login/googleauth/googleauth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget menuTile({
    required IconData icon,
    required String title,
    bool highlight = false,
  }) {
    const primary = Color(0xff5B5FEF);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: highlight ? primary.withValues(alpha: .10) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
                color: highlight ? primary : Colors.black87,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF5F6FA),
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
                      color: Color(0xff5B5FEF),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF000000).withValues(alpha: 0.2),
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
                color: Color(0xff5B5FEF).withValues(alpha: .12),
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  menuTile(
                    icon: Icons.person,
                    title: "Profile Details",
                    highlight: true,
                  ),
                  menuTile(
                    icon: Icons.shield_outlined,
                    title: "Security & Password",
                  ),
                  menuTile(
                    icon: Icons.notifications_none,
                    title: "Notification Preferences",
                  ),
                  menuTile(icon: Icons.link, title: "Connected Accounts"),
                  menuTile(
                    icon: Icons.manage_accounts_outlined,
                    title: "Account Management",
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<GoogleAuth>(
                builder: (context, value, child) => ElevatedButton.icon(
                  onPressed: () {
                    value.logout();
                  },
                  label: Text(
                    "Log Out",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenwidth * 0.9, 50),
                    iconAlignment: IconAlignment.end,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color.fromARGB(255, 28, 133, 252),
                    elevation: 0,
                  ),
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
