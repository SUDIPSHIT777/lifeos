import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget coreCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
}) {
  final width = MediaQuery.sizeOf(context).width;

  return Container(
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(28),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.04),
          blurRadius: 14,
          offset: const Offset(0, 8),
        ),
      ],
    ),

    child: Stack(
      children: [
        /// FADED BACKGROUND ICON
        Positioned(
          right: -5,
          bottom: -10,

          child: Icon(
            icon,
            size: width * 0.20,
            color: iconColor.withValues(alpha: 0.08),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ICON
            Container(
              width: width * 0.14,
              height: width * 0.14,

              decoration: BoxDecoration(
                color: iconColor.withValues(alpha:0.14),
                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: iconColor, size: width * 0.06),
            ),

            const Spacer(),

            /// TITLE
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                fontSize: width * 0.042,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            /// SUBTITLE
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.poppins(
                fontSize: width * 0.032,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// ================= SMART CARD =================
Widget smartCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
}) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.04),
          blurRadius: 14,
          offset: const Offset(0, 8),
        ),
      ],
    ),

    child: Stack(
      children: [
        /// FADED ICON
        Positioned(
          right: 5,
          bottom: -5,

          child: Icon(
            icon,
            size: width * 0.15,
            color: iconColor.withValues(alpha:0.08),
          ),
        ),

        Row(
          children: [
            /// ICON
            Container(
              width: width * 0.14,
              height: width * 0.14,

              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: iconColor, size: width * 0.06),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: width * 0.034,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
