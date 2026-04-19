import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonwidget {
  // ========================== Button ==============================
  Widget button({
    required String titel,
    required IconData icon,
    required Color? backgroundcolor,
    required Color? iconcolor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: backgroundcolor ?? const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconcolor ?? const Color(0xff3B82F6),
            fontWeight: FontWeight.w500,
            size: 27.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          titel,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xff6B7280),
          ),
        ),
      ],
    );
  }

}
