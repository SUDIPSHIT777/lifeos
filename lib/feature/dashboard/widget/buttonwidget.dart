import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttonwidget {
  /// ================= PREMIUM BUTTON =================
  Widget button(
    BuildContext context, {
    required String titel,
    required IconData icon,
    required Color backgroundcolor,
    required Color iconcolor,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      width: width * 0.42,
      constraints: const BoxConstraints(minHeight: 145),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * .14,
            height: width * .14,
            decoration: BoxDecoration(
              color: iconcolor.withValues(alpha: .14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconcolor, size: width * .06),
          ),

          SizedBox(height: width * .06),

          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: AutoSizeText(
                titel,
                maxLines: 2,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: width * .035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
