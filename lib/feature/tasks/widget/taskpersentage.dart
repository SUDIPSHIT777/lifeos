import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Taskpersentage {
  Widget dailyProgressCard({
    required int completed,
    required int total,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff1E3A8A), Color(0xff4F46E5), Color(0xff8B5CF6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Progress",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                "$completed of $total tasks completed\nDo all Task it's mandatory",
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: .9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Consumer<Taskprovider>(
            builder: (context, taskprovider, child) {
              final color = taskprovider.percentagecolor(percent);

              return CircularPercentIndicator(
                radius: 42,
                lineWidth: 7,
                percent: percent,
                animation: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white.withValues(alpha: .25),
                progressColor: color,
                center: Text(
                  "${(percent * 100).toInt()}%",
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
