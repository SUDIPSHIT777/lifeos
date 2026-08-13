import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/model/financemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseProvider extends ChangeNotifier {
  static const String _prefsKey = 'lifeos_finance_expenses_v4';
  static const String _balanceKey = 'lifeos_finance_base_balance_v4';

  double _baseBalance = 0.0;
  List<Expense> _expenses = [];
  bool _isLoading = false;
  ExpenseProvider() {
    _loadInitialData();
  }

  // Getters
  bool get isLoading => _isLoading;
  double get baseBalance => _baseBalance;

  double get totalExpense {
    return _expenses
        .where((e) => e.type == TransactionType.expense)
        .fold(0.0, (acc, expense) => acc + expense.amount);
  }

  double get totalBalance {
    return _baseBalance - totalExpense;
  }

  bool get isDeficit => totalBalance < 0;

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 2,
    );
    final absFormatted = formatter.format(amount.abs());
    return amount < 0 ? '-$absFormatted' : absFormatted;
  }

  String get formattedBalance => formatCurrency(totalBalance);
  String get formattedBaseBalance => formatCurrency(_baseBalance);
  String get formattedTotalExpense => formatCurrency(totalExpense);

  String get percentageText {
    if (_baseBalance > 0) {
      final ratio = (totalBalance / _baseBalance) * 100;
      return ratio > 0
          ? '+${ratio.toStringAsFixed(1)}%'
          : '${ratio.toStringAsFixed(1)}%';
    } else if (totalExpense > 0) {
      return '-100.0%';
    } else {
      return '0.0%';
    }
  }

  List<Expense> get recentExpenses {
    final sorted = List<Expense>.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};
    for (var expense in _expenses) {
      if (expense.type == TransactionType.expense) {
        totals[expense.category] =
            (totals[expense.category] ?? 0.0) + expense.amount;
      }
    }
    return totals;
  }

  /// Sets / Replaces the base balance (e.g. set 200 replaces 100 with 200, no addition!)
  Future<void> setBaseBalance(double newBalance) async {
    _baseBalance = newBalance;
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> addExpense({
    required String category,
    required double amount,
    String? title,
    TransactionType type = TransactionType.expense,
    DateTime? date,
  }) async {
    if (type == TransactionType.income) {
      // Setting income updates base balance directly without accumulation
      _baseBalance = amount;
    } else {
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        category: category,
        amount: amount,
        type: type,
        date: date ?? DateTime.now(),
      );
      _expenses.insert(0, newExpense);
      await _syncExpenseToFirestore(newExpense);
    }

    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> removeExpense(Expense expense) async {
    _expenses.removeWhere((e) => e.id == expense.id);
    notifyListeners();

    await _saveToPrefs();
    await _deleteExpenseFromFirestore(expense.id);
  }

  Future<void> clearAll() async {
    final idsToDelete = _expenses.map((e) => e.id).toList();
    _expenses.clear();
    _baseBalance = 0.0;
    notifyListeners();

    await _saveToPrefs();
    for (var id in idsToDelete) {
      await _deleteExpenseFromFirestore(id);
    }
  }

  // Data Persistence
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_balanceKey)) {
        _baseBalance = prefs.getDouble(_balanceKey) ?? 0.0;
      }

      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
      } else {
        _expenses = [];
        await _saveToPrefs();
      }

      await _loadFromFirestore();
    } catch (e) {
      debugPrint('Error loading expense data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .get();

        if (snapshot.docs.isNotEmpty) {
          final firestoreExpenses = snapshot.docs
              .map((doc) => Expense.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
          _expenses = firestoreExpenses;
          await _saveToPrefs();
        }
      }
    } catch (e) {
      debugPrint('Firestore load skipped: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _expenses.map((e) => e.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(jsonList));
      await prefs.setDouble(_balanceKey, _baseBalance);
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }
  }

  Future<void> _syncExpenseToFirestore(Expense expense) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .doc(expense.id)
            .set(expense.toJson());
      }
    } catch (e) {
      debugPrint('Firestore sync failed: $e');
    }
  }

  Future<void> _deleteExpenseFromFirestore(String id) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .doc(id)
            .delete();
      }
    } catch (e) {
      debugPrint('Firestore delete failed: $e');
    }
  }
}
