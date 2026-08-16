import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/model/habitmodel.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];
  StreamSubscription<List<HabitModel>>? _habitsSubscription;
  bool _isLoading = true;

  List<HabitModel> get habits => _habits;
  bool get isLoading => _isLoading;

  HabitProvider() {
    _initFirebaseListener();
  }

  void _initFirebaseListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _habitsSubscription?.cancel();
      if (user != null) {
        _subscribeToHabits(user.uid);
      } else {
        _habits = [];
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _subscribeToHabits(String uid) {
    _isLoading = true;
    notifyListeners();

    _habitsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('habits')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => HabitModel.fromFirestore(doc)).toList();
    }).listen((fetchedHabits) {
      _habits = fetchedHabits;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Error fetching habits: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  int get remainingCount => _habits.where((h) => !h.isCompleted).length;
  int get completedCount => _habits.where((h) => h.isCompleted).length;

  double get completionRatio {
    if (_habits.isEmpty) return 0.0;
    return completedCount / _habits.length;
  }

  int get totalStreak {
    if (_habits.isEmpty) return 0;
    int maxStreak = 0;
    for (var h in _habits) {
      if (h.streak > maxStreak) maxStreak = h.streak;
    }
    return maxStreak;
  }

  Future<void> addHabit({
    required String title,
    required String categoryTag,
    required int iconCode,
    required int colorValue,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();

    final newHabit = HabitModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      categoryTag: categoryTag,
      iconCode: iconCode,
      colorValue: colorValue,
      isCompleted: false,
      streak: 0,
      completedDates: [],
      createdAt: now,
    );

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(newHabit.id)
          .set(newHabit.toFirestore());
    } else {
      _habits.add(newHabit);
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(HabitModel habit) async {
    final user = FirebaseAuth.instance.currentUser;
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final bool newStatus = !habit.isCompleted;
    List<String> updatedDates = List.from(habit.completedDates);
    int newStreak = habit.streak;

    if (newStatus) {
      if (!updatedDates.contains(todayStr)) {
        updatedDates.add(todayStr);
        newStreak += 1;
      }
    } else {
      updatedDates.remove(todayStr);
      if (newStreak > 0) newStreak -= 1;
    }

    final updatedHabit = habit.copyWith(
      isCompleted: newStatus,
      streak: newStreak,
      completedDates: updatedDates,
    );

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habit.id)
          .update(updatedHabit.toFirestore());
    } else {
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = updatedHabit;
        notifyListeners();
      }
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habitId)
          .delete();
    } else {
      _habits.removeWhere((h) => h.id == habitId);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _habitsSubscription?.cancel();
    super.dispose();
  }
}
