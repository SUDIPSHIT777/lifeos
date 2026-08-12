import 'package:flutter/material.dart';

Widget balanceCard({VoidCallback? onAdd, VoidCallback? onSend}) {
  Widget actionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 19),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  return Container(
    width: double.infinity,
    height: 220, // Fixed height
    constraints: const BoxConstraints(maxWidth: 460),
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF315DE5), Color(0xFF2050D6)],
      ),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Balance',
          style: TextStyle(
            color: Color(0xFFDDE5FF),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '\$12,450.80',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.2,
                height: 1,
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '+2.4%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 34),

        Row(
          children: [
            Expanded(
              child: actionButton(
                icon: Icons.add_circle_outline,
                label: 'Add',
                onTap: onAdd,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: actionButton(
                icon: Icons.send_outlined,
                label: 'Send',
                onTap: onSend,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
