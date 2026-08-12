import 'package:flutter/material.dart';
import 'package:lifeos/feature/finance/controller/expenssprovider.dart';
import 'package:lifeos/model/financemodel.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

Widget spendingBreakdown({VoidCallback? onDetails}) {
  return Consumer<ExpenseProvider>(
    builder: (context, provider, child) {
      final expenses = provider.expenses;
      final total = provider.totalExpense;

      return Container(
        width: double.infinity,
        height: 280,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE0E5ED)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Breakdown',
                  style: TextStyle(
                    color: Color(0xFF07152B),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                GestureDetector(
                  onTap: onDetails,
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color: Color(0xFF315DE5),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // CONTENT
            Expanded(
              child: Row(
                children: [
                  // DONUT
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ..._buildDonutSegments(provider, expenses),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Spent',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              _formatAmount(total),
                              style: const TextStyle(
                                color: Color(0xFF07152B),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  // LEGEND
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenses.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final expense = expenses[index];

                        return _spendingItem(
                          color: _categoryColor(index),
                          title: expense.category,
                          amount: expense.amount,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

List<Widget> _buildDonutSegments(
  ExpenseProvider provider,
  List<Expense> expenses,
) {
  double startAngle = 270;

  final List<Widget> segments = [];

  for (int i = 0; i < expenses.length; i++) {
    final expense = expenses[i];

    final double percent = provider.getPercentage(expense.amount);

    if (percent <= 0) {
      continue;
    }

    segments.add(
      CircularPercentIndicator(
        radius: 65,
        lineWidth: 16,
        percent: percent.clamp(0.0, 1.0),
        startAngle: startAngle % 360,
        animation: false,
        backgroundColor: Colors.transparent,
        progressColor: _categoryColor(i),
        circularStrokeCap: CircularStrokeCap.butt,
      ),
    );

    startAngle += percent * 360;
  }

  return segments;
}

Widget _spendingItem({
  required Color color,
  required String title,
  required double amount,
}) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),

      const SizedBox(width: 10),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
            ),

            const SizedBox(height: 2),

            Text(
              _formatAmount(amount),
              style: const TextStyle(
                color: Color(0xFF07152B),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Color _categoryColor(int index) {
  const colors = [
    Color(0xFF315DE5),
    Color(0xFF10B981),
    Color(0xFFFFB51B),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
  ];

  return colors[index % colors.length];
}

String _formatAmount(double amount) {
  return '\$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]},')}';
}
