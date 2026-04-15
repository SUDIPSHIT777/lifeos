import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF7B4DFF), size: 30),
                  Text(
                    "LIFEOS",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage("assets/logos.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "Intelligence",
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2B2B2B),
                ),
              ),

              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    colors: [Color(0xFF6C3BFF), Color(0xFFB14DFF)],
                  ).createShader(rect);
                },
                child: Text(
                  "Reimagined.",
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Unified Workspace for Tasks,\nNotes, and AI Intelligence.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  height: 1.5,
                  fontSize: 15.5,
                  color: Color(0xFF6B6B6B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 26),
              LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Color(0xFFE6E7EC),
                valueColor: AlwaysStoppedAnimation(Color(0xFF7B4DFF)),
                borderRadius: BorderRadius.circular(10),
              ),

              const SizedBox(height: 26),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6F3CFF), Color(0xFF9B4DFF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF7B4DFF).withValues(alpha: .4),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Initializing Workspace",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "ENTERPRISE SECURE   •   V1.0.0PLATINUM",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
