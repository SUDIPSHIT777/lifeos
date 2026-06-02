import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/ai_assistant/widget/cardwidget.dart';
import 'package:lifeos/feature/ai_assistant/widget/tilewidget.dart';

class AiDashboard extends StatelessWidget {
  const AiDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),

          child: Container(
            margin: const EdgeInsets.all(6),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: IconButton(
              onPressed: () => Navigator.pop(context),

              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),

        centerTitle: true,

        title: Column(
          children: [
            Text(
              "AI Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            Text(
              "Smart Productivity",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),

            child: Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),

      /// ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// HEADER
              Text(
                "Welcome Back 👋",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.075,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Explore AI-powered productivity tools",
                style: GoogleFonts.poppins(
                  fontSize: width * 0.038,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 34),

              /// ================= CORE ACTIONS =================
              sectionTitle("Core Actions"),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.05,

                children: [
                  coreCard(
                    context,
                    title: "Chat with AI",
                    subtitle: "Text based assistant",
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: const Color(0xFF4C6FFF),
                    backgroundColor: const Color(0xFFEFF2FF),
                  ),

                  coreCard(
                    context,
                    title: "Talk with AI",
                    subtitle: "Natural conversation",
                    icon: Icons.mic_none_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    backgroundColor: const Color(0xFFF3ECFF),
                  ),

                  coreCard(
                    context,
                    title: "Translate",
                    subtitle: "AI translator",
                    icon: Icons.translate_rounded,
                    iconColor: const Color(0xFF06B6D4),
                    backgroundColor: const Color(0xFFE7FBFF),
                  ),

                  coreCard(
                    context,
                    title: "Scanner",
                    subtitle: "Scan text & images",
                    icon: Icons.document_scanner_outlined,
                    iconColor: const Color(0xFF10B981),
                    backgroundColor: const Color(0xFFEAFBF5),
                  ),
                ],
              ),

              const SizedBox(height: 34),

              /// ================= SMART ACTIONS =================
              sectionTitle("Smart Quick Actions"),

              const SizedBox(height: 18),

              smartCard(
                context,
                title: "Compose Email",
                subtitle: "Write professional emails easily",
                icon: Icons.email_outlined,
                iconColor: const Color(0xFFFF5DA2),
                backgroundColor: const Color(0xFFFFEEF5),
              ),

              const SizedBox(height: 16),

              smartCard(
                context,
                title: "Generate Ideas",
                subtitle: "Brainstorm creative concepts",
                icon: Icons.lightbulb_outline_rounded,
                iconColor: const Color(0xFFFF9800),
                backgroundColor: const Color(0xFFFFF3E6),
              ),

              const SizedBox(height: 16),

              smartCard(
                context,
                title: "Plan Tasks",
                subtitle: "Organize your workflow",
                icon: Icons.task_alt_rounded,
                iconColor: const Color(0xFF4C6FFF),
                backgroundColor: const Color(0xFFEFF2FF),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
