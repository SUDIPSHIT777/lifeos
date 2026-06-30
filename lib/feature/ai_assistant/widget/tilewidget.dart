import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget sectionTitle(String title) {
  return Row(
    children: [
      Container(
        width: 5,
        height: 24,

        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      const SizedBox(width: 10),

      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
