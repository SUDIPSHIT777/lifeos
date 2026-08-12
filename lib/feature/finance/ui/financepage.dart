import 'package:flutter/material.dart';
import 'package:lifeos/feature/ai_assistant/widget/tilewidget.dart';
import 'package:lifeos/feature/finance/ui/expensstracker.dart';
import 'package:lifeos/feature/finance/widget/blancecard.dart';
import 'package:lifeos/feature/finance/widget/spend.dart';

class Financepage extends StatefulWidget {
  const Financepage({super.key});

  @override
  State<Financepage> createState() => _FinancepageState();
}

class _FinancepageState extends State<Financepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,

        leading: const SizedBox(),
        centerTitle: true,

        title: const Text(
          "Finance Tracker",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsetsGeometry.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              balanceCard(onAdd: () {}, onSend: () {}),
              SizedBox(height: 20),
              sectionTitle("Spending Chart"),
              SizedBox(height: 20),
              spendingBreakdown(),
              SizedBox(height: 20),
              sectionTitle("Recent Transactions"),
              SizedBox(height: 20),
              transactionList(),
            ],
          ),
        ),
      ),
    );
  }
}
