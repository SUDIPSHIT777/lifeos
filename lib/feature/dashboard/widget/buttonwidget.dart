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
    final width = MediaQuery.of(context).size.width;

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

      child: Stack(
        children: [
          Positioned(
            right: -5,
            bottom: 10,

            child: Icon(
              icon,
              size: width * 0.14,
              color: iconcolor.withValues(alpha:0.06),
            ),
          ),

          /// CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// TOP ICON
              Container(
                width: width * 0.14,
                height: width * 0.14,

                decoration: BoxDecoration(
                  color: iconcolor.withValues(alpha:0.14),
                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: iconcolor, size: width * 0.06),
              ),

              const Spacer(),

              /// TITLE
              Text(
                titel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: GoogleFonts.poppins(
                  fontSize: width * 0.042,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
