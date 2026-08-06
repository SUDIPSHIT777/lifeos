import 'package:flutter/material.dart';

Widget coreCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      return Container(
        padding: EdgeInsets.all(w * 0.08),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(w * 0.08),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: w * 0.06,
              offset: Offset(0, w * 0.03),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -w * 0.03,
              bottom: -w * 0.05,
              child: Icon(
                icon,
                size: w * 0.32,
                color: iconColor.withValues(alpha: 0.08),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: w * 0.26,
                  height: w * 0.26,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: w * 0.12, color: iconColor),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: w * 0.085,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: w * 0.06,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
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
          color: Colors.black.withValues(alpha: 0.04),
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
            color: iconColor.withValues(alpha: 0.08),
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

                    style: TextStyle(
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

                    style: TextStyle(
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
