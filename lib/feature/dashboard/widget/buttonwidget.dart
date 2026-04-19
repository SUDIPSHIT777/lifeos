import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonwidget {
  // ========================== Button ==============================
  Widget button(
    BuildContext context, {
    required String titel,
    required IconData icon,
    required Color backgroundcolor,
    required Color iconcolor,
  }) {
    return Container(
      height: 120,
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: iconcolor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconcolor, size: 22),
          ),
          const Spacer(),
          Text(
            titel,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
