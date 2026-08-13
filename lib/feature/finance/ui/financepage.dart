import 'package:flutter/material.dart';
import 'package:lifeos/feature/ai_assistant/widget/tilewidget.dart';
import 'package:lifeos/feature/finance/controller/expenssprovider.dart';
import 'package:lifeos/feature/finance/ui/add_transaction_modal.dart';
import 'package:lifeos/feature/finance/ui/expensstracker.dart';
import 'package:lifeos/feature/finance/widget/blancecard.dart';
import 'package:lifeos/feature/finance/widget/spend.dart';
import 'package:provider/provider.dart';

class Financepage extends StatefulWidget {
  const Financepage({super.key});

  @override
  State<Financepage> createState() => _FinancepageState();
}

class _FinancepageState extends State<Financepage> {
  void _showClearConfirmDialog(BuildContext context, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'Are you sure you want to clear all expenses and reset balance to ₹0.00?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All finance data reset')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.payments, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Finance Tracker',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              final provider = Provider.of<ExpenseProvider>(
                context,
                listen: false,
              );
              if (value == 'clear') {
                _showClearConfirmDialog(context, provider);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_rounded,
                      size: 20,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Reset All Data',
                      style: TextStyle(color: Colors.red, fontWeight: .bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              balanceCard(
                onAdd: () {
                  AddTransactionModal.show(context, mode: ModalMode.setBalance);
                },
                onSend: () {
                  AddTransactionModal.show(context, mode: ModalMode.addExpense);
                },
              ),

              const SizedBox(height: 20),
              // Spending Chart Section
              sectionTitle("Spending Chart"),
              const SizedBox(height: 14),
              spendingBreakdown(),

              const SizedBox(height: 24),

              // Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sectionTitle("Recent Transactions"),
                  TextButton(
                    onPressed: () {
                      AddTransactionModal.show(
                        context,
                        mode: ModalMode.addExpense,
                      );
                    },
                    child: const Text(
                      '+ Log Expense',
                      style: TextStyle(
                        color: Color(0xFF315DE5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Transaction List
              transactionList(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AddTransactionModal.show(context, mode: ModalMode.addExpense);
        },
        backgroundColor: const Color(0xFF315DE5),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Expense',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
