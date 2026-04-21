import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/timerset.dart';
import 'package:provider/provider.dart';

void openTimePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF2F3336),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        child: Consumer<FocusTimerProvider>(
          builder: (context, timer, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Focus Time",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Slider(
                  value: timer.pickerMinutes,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  label: "${timer.pickerMinutes.round()} min",
                  onChanged: (value) => timer.updatePicker(value),
                ),

                Text(
                  "${timer.pickerMinutes.round()} minutes",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      timer.setMinutes(timer.pickerMinutes.round());
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Apply",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
