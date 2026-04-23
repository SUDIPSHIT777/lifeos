import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  /// FORMAT
  String formatDate() {
    if (_selectedDate == null) return "Select Date";
    return DateFormat('dd MMM yyyy').format(_selectedDate!);
  }

  String formatTime() {
    if (_selectedTime == null) return "Select Time";

    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    return DateFormat('hh:mm a').format(dt);
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
              primary: Color(0xFF4F46E5), // header + selected date
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),

            /// 🔘 Buttons (OK / Cancel)
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
              primary: Color(0xFF4F46E5), // dial + selected
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),

            /// ⏰ Time picker styling
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,

              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
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

  void setInitial(DateTime? date, TimeOfDay? time) {
    _selectedDate = date;
    _selectedTime = time;
  }
}
