import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/widget/timer.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/feature/dashboard/controller/timerset.dart';

class FocusTimer extends StatelessWidget {
  const FocusTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2F3336),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Consumer<FocusTimerProvider>(
        builder: (context, timer, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "DEEP FOCUS MODE",
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 16,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                timer.formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (timer.isRunning) {
                          timer.pause();
                        } else {
                          timer.start();
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: !timer.isRunning
                              ? Colors.white
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timer.isRunning ? "Pause" : "Start session",
                          style: TextStyle(
                            color: timer.isRunning
                                ? Color(0xFFFFFFFF)
                                : Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: timer.reset,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF000000), width: 2),
                        color: Colors.black,
                      ),
                      child: const Icon(Icons.refresh, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => openTimePicker(context),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF000000), width: 2),
                        color: Colors.black,
                      ),
                      child: const Icon(Icons.timer, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
