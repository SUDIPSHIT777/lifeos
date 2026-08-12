import 'package:flutter/foundation.dart';
import 'package:lifeos/model/financemodel.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(
      category: 'Food',
      amount: 960,
    ),
    Expense(
      category: 'Rent',
      amount: 1920,
    ),
    Expense(
      category: 'Fun',
      amount: 320,
    ),
  ];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  double get totalExpense {
    return _expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  double getCategoryTotal(String category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(
          0,
          (sum, expense) => sum + expense.amount,
        );
  }

  double getPercentage(double amount) {
    if (totalExpense == 0) {
      return 0;
    }

    return amount / totalExpense;
  }

  List<String> get categories {
    return _expenses
        .map((expense) => expense.category)
        .toSet()
        .toList();
  }

  void addExpense({
    required String category,
    required double amount,
  }) {
    _expenses.add(
      Expense(
        category: category,
        amount: amount,
      ),
    );

    notifyListeners();
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  void clearExpenses() {
    _expenses.clear();
    notifyListeners();
  }
}