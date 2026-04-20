import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/timerset.dart';
import 'package:provider/provider.dart';

class Timerwidget {
  Widget focoustimer() {
    return Consumer<FocusTimerProvider>(
      builder: (context, timer, child) {
        return Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2F3336),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "DEEP FOCUS MODE",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                // ⏱ TIMER DISPLAY
                Text(
                  timer.formattedTime,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // 🎮 CONTROLS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: timer.isRunning
                            ? Colors.orange
                            : Colors.white,
                        foregroundColor: timer.isRunning
                            ? Colors.white
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (timer.isRunning) {
                          timer.stop(); // acts like pause
                        } else {
                          timer.start();
                        }
                      },
                      child: Text(
                        timer.isRunning ? "Pause" : "Start",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 🔄 RESET
                    InkWell(
                      onTap: timer.reset,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // ⏱ SET TIME
                    InkWell(
                      onTap: () {
                        final provider = context
                            .read<FocusTimerProvider>(); // safe

                        final minuteController = TextEditingController();
                        final hourController = TextEditingController();

                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: const Color(0xFF2F3336),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Set Timer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // ⏱ Inputs Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: hourController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: _inputDecoration(
                                              "Hours",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: TextFormField(
                                            controller: minuteController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: _inputDecoration(
                                              "Minutes",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // 🔘 Actions
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogContext),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.white24,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              final hours =
                                                  int.tryParse(
                                                    hourController.text,
                                                  ) ??
                                                  0;
                                              final minutes =
                                                  int.tryParse(
                                                    minuteController.text,
                                                  ) ??
                                                  0;

                                              provider.setDuration(
                                                hours: hours,
                                                minutes: minutes,
                                              );

                                              Navigator.pop(dialogContext);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Set",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        child: const Icon(Icons.timer, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white10,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
