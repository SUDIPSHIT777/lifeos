import 'package:flutter/material.dart';

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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
