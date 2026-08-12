import 'package:flutter/material.dart';

Widget transactionList() {
  return ListView.builder(
    itemCount: 5,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Container(
        height: 82,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E5ED)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF1FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant,
                color: Color(0xFF315DE5),
                size: 25,
              ),
            ),

            const SizedBox(width: 16),

            // Name + Date
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Burger House',
                    style: TextStyle(
                      color: Color(0xFF07152B),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'Today, 12:45 PM',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ],
              ),
            ),

            // Amount
            const Text(
              '-\$42.00',
              style: TextStyle(
                color: Color(0xFFFF3B3B),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    },
  );
}
