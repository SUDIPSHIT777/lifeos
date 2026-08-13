import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TransactionType { expense, income }

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<ExpenseCategory> defaultCategories = [
    ExpenseCategory(
      name: 'Food',
      icon: Icons.restaurant_rounded,
      color: Color(0xFF315DE5),
    ),
    ExpenseCategory(
      name: 'Rent',
      icon: Icons.home_rounded,
      color: Color(0xFF10B981),
    ),
    ExpenseCategory(
      name: 'Fun',
      icon: Icons.sports_esports_rounded,
      color: Color(0xFFFFB51B),
    ),
    ExpenseCategory(
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFF8B5CF6),
    ),
    ExpenseCategory(
      name: 'Bills',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFFEF4444),
    ),
    ExpenseCategory(
      name: 'Salary',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF10B981),
    ),
    ExpenseCategory(
      name: 'Investment',
      icon: Icons.trending_up_rounded,
      color: Color(0xFF06B6D4),
    ),
    ExpenseCategory(
      name: 'Other',
      icon: Icons.category_rounded,
      color: Color(0xFF64748B),
    ),
  ];

  static ExpenseCategory getByName(String name) {
    return defaultCategories.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => const ExpenseCategory(
        name: 'Other',
        icon: Icons.category_rounded,
        color: Color(0xFF64748B),
      ),
    );
  }
}

class Expense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;

  Expense({
    String? id,
    String? title,
    required this.category,
    required this.amount,
    this.type = TransactionType.expense,
    DateTime? date,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title = (title != null && title.isNotEmpty) ? title : category,
        date = date ?? DateTime.now();

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  IconData get categoryIcon => ExpenseCategory.getByName(category).icon;
  Color get categoryColor => ExpenseCategory.getByName(category).color;

  String get formattedAmount {
    final formatter =
        NumberFormat.currency(symbol: '₹', locale: 'en_IN', decimalDigits: 2);
    final absFormatted = formatter.format(amount.abs());
    return isIncome ? '+$absFormatted' : '-$absFormatted';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    final timeStr = DateFormat('h:mm a').format(date);

    if (itemDate == today) {
      return 'Today, $timeStr';
    } else if (itemDate == yesterday) {
      return 'Yesterday, $timeStr';
    } else {
      return '${DateFormat('MMM d').format(date)}, $timeStr';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String? ?? 'Other',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}