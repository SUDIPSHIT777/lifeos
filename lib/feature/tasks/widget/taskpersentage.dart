import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Taskpersentage {
  Widget dailyProgressCard({
    required BuildContext context,
    required int completed,
    required int total,
    required double percent,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    final radius = (width * 0.11).clamp(34.0, 46.0);
    final lineWidth = (width * 0.018).clamp(5.0, 8.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * .05,
        vertical: width * .045,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff1E3A8A), Color(0xff4F46E5), Color(0xff8B5CF6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Daily Progress",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: (width * .045).clamp(15.0, 18.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: width * .015),

                Text(
                  "$completed of $total tasks completed\nDo all tasks. It's mandatory.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: (width * .033).clamp(11.0, 14.0),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: width * .04),

          /// Progress
          Consumer<Taskprovider>(
            builder: (context, taskprovider, child) {
              final color = taskprovider.percentagecolor(percent);
              return SizedBox(
                width: radius * 2,
                height: radius * 2,
                child: CircularPercentIndicator(
                  radius: radius,
                  lineWidth: lineWidth,
                  percent: percent.clamp(0.0, 1.0),
                  animation: true,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.white.withValues(alpha: .25),
                  progressColor: color,
                  center: FittedBox(
                    child: Text(
                      "${(percent * 100).toInt()}%",
                      style: GoogleFonts.poppins(
                        color: color,
                        fontSize: radius * .42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
