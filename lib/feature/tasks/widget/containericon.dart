import 'package:flutter/material.dart';

Widget simpleContainer({
  required String title,
  required String subtitle,
  required IconData icon,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
        width: 1,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ICON
        Icon(
          icon,
          size: 32,
          color: const Color(0xFFB8B8B8),
        ),

        const SizedBox(height: 8),

        /// TITLE
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 4),

        /// SUBTITLE
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    ),
  );
}