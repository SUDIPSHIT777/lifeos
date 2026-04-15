import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/model/taskmodel.dart';

class Taskprovider extends ChangeNotifier {
  // ================= Task Data Start =================
  final List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  List<TaskModel> get todayTasks {
    return _tasks.where((task) {
      return _isToday(task.date ?? task.createdAt);
    }).toList();
  }

  int get todayTotal => todayTasks.length;
  int get todayCompleted => todayTasks.where((t) => t.isCompleted).length;
  double get todayPercent => todayTotal == 0 ? 0 : todayCompleted / todayTotal;

  void setTasks(List<TaskModel> newTasks) {
    _tasks.clear();
    _tasks.addAll(newTasks);
    notifyListeners();
  }

  // ================= Completed Section ==============
  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<TaskModel> get activeTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  // ================= UI State =================
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'medium';

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get priority => _priority;

  // ================= Actions =================

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF4F46E5),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hourMinuteColor: Colors.grey.shade100,
              dayPeriodColor: Colors.grey.shade200,
              dialHandColor: const Color(0xFF4F46E5),
              dialBackgroundColor: Colors.grey.shade100,
              entryModeIconColor: const Color(0xFF4F46E5),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4F46E5),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedTime = picked;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      if (_selectedDate == null) {
        throw Exception("Please select a date");
      }
      final taskRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc();

      await taskRef.set({
        'title': title,
        'desc': description,
        'date': selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
        'time': selectedTime != null
            ? '${selectedTime!.hour}:${selectedTime!.minute}'
            : null,
        'priority': priority,
        'isCompleted': false,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Error Adding Task,Task Not Add");
    } finally {
      _selectedDate = null;
      _selectedTime = null;
      _priority = 'medium';
      notifyListeners();
    }
  }

  Stream<List<TaskModel>> getTasks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          final tasks = snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList();
          setTasks(tasks);
          return tasks;
        });
  }

  Future<void> toggleTask(TaskModel task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _tasks[index].isCompleted = !_tasks[index].isCompleted;
      }

      notifyListeners();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(task.id)
          .update({'isCompleted': _tasks[index].isCompleted});
    } catch (e) {
      debugPrint("Toggle failed: $e");
    }
  }

  // ============== Colors Function ================
  IconData getPriorityIcon(String priority) {
    switch (priority) {
      case "high":
        return Icons.local_fire_department;
      case "medium":
        return Icons.flash_on;
      case "low":
        return Icons.eco;
      default:
        return Icons.flag;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color percentagecolor(double percentage) {
    if (percentage <= 0.3) {
      return Colors.red;
    } else if (percentage <= 0.7) {
      return Colors.orange;
    } else {
      return Color.fromARGB(255, 83, 216, 87);
    }
  }

  // ====================== Audio ====================
  final AudioPlayer _player = AudioPlayer();
  Future<void> playAudio() async {
    await _player.play(AssetSource("pop.mp3"));
  }

  // =============== Group Task =================
  Map<DateTime, List<TaskModel>> groupTasks(List<TaskModel> tasks) {
    Map<DateTime, List<TaskModel>> grouped = {};
    for (var task in tasks) {
      if (task.date == null) continue;
      final date = DateTime(task.date!.year, task.date!.month, task.date!.day);
      grouped.putIfAbsent(date, () => []).add(task);
    }
    return grouped;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final inputDate = DateTime(date.year, date.month, date.day);
    if (inputDate == today) return "Today";
    if (inputDate == tomorrow) return "Tomorrow";
    return "${date.day}/${date.month}/${date.year}";
  }
}
