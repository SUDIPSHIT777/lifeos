import 'package:flutter/material.dart';
import 'package:lifeos/feature/finance/controller/expenssprovider.dart';
import 'package:lifeos/model/financemodel.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

Widget spendingBreakdown({VoidCallback? onDetails}) {
  return Consumer<ExpenseProvider>(
    builder: (context, provider, child) {
      final total = provider.totalExpense;
      final formattedTotal = provider.formattedTotalExpense;

      // Group expenses by category
      final categoryTotals = provider.categoryTotals;
      final categoryEntries = categoryTotals.entries.toList();

      return Container(
        width: double.infinity,
        height: 480,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE0E5ED)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                  onTap:
                      onDetails ??
                      () => _showCategoryDetailsSheet(context, provider),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color: Color(0xFF315DE5),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // DONUT - TOP
            Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (categoryEntries.isEmpty || total == 0)
                      CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 16,
                        percent: 1.0,
                        animation: false,
                        backgroundColor: const Color(0xFFF1F5F9),
                        progressColor: const Color(0xFFCBD5E1),
                      )
                    else
                      ..._buildDonutCategorySegments(total, categoryEntries),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Spent',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 2),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            formattedTotal,
                            style: const TextStyle(
                              color: Color(0xFF07152B),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LEGEND - BOTTOM
            Expanded(
              child: categoryEntries.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses recorded yet',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categoryEntries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final entry = categoryEntries[index];
                        final categoryObj = ExpenseCategory.getByName(
                          entry.key,
                        );
                        final percentage = total > 0
                            ? (entry.value / total) * 100
                            : 0.0;

                        return _spendingItem(
                          color: categoryObj.color,
                          title: entry.key,
                          formattedAmount: provider.formatCurrency(entry.value),
                          percentage: percentage,
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}

List<Widget> _buildDonutCategorySegments(
  double totalExpense,
  List<MapEntry<String, double>> categoryEntries,
) {
  double startAngle = 270;
  final List<Widget> segments = [];

  for (int i = 0; i < categoryEntries.length; i++) {
    final entry = categoryEntries[i];
    final categoryObj = ExpenseCategory.getByName(entry.key);
    final double percent = totalExpense > 0 ? entry.value / totalExpense : 0;

    if (percent <= 0) continue;

    segments.add(
      CircularPercentIndicator(
        radius: 70,
        lineWidth: 16,
        percent: percent.clamp(0.0, 1.0),
        startAngle: startAngle % 360,
        animation: false,
        backgroundColor: Colors.transparent,
        progressColor: categoryObj.color,
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
  required String formattedAmount,
  required double percentage,
}) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            Text(
              formattedAmount,
              style: const TextStyle(
                color: Color(0xFF07152B),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

void _showCategoryDetailsSheet(BuildContext context, ExpenseProvider provider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final categoryTotals = provider.categoryTotals;
      final totalSpent = provider.totalExpense;

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Spending Analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07152B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Total Expenses: ${provider.formattedTotalExpense}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const Divider(height: 24),
            Expanded(
              child: categoryTotals.isEmpty
                  ? const Center(child: Text('No expense data available.'))
                  : ListView(
                      children: categoryTotals.entries.map((entry) {
                        final catObj = ExpenseCategory.getByName(entry.key);
                        final pct = totalSpent > 0
                            ? (entry.value / totalSpent) * 100
                            : 0.0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: catObj.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(catObj.icon, color: catObj.color),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${pct.toStringAsFixed(1)}% of total spent',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                provider.formatCurrency(entry.value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF07152B),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      );
    },
  );
}
