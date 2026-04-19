import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/provider.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Cardwidget {
  Widget morningdetails(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF4336E0), Color(0xFF493DE0)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<Userprovider>(
              builder: (context, time, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Consumer<Userprovider>(
                        builder: (context, value, child) {
                          return Row(
                            spacing: 10,
                            children: [
                              Text(
                                "${value.gettime},",
                                style: GoogleFonts.poppins(
                                  fontSize: screenwidth * 0.05,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Image.asset(value.imagePath, height: 30),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    time.time,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    time.date,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: screenwidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "72°F",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "CLEAR\nSKIES",
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============= Finance Card Details =======================
  Widget monthlySpendingCard({
    required double totalSpending,
    required double dailyUsed,
    required double dailyLimit,
    required double percentChange,
  }) {
    final progress = dailyUsed / dailyLimit;

    final titleStyle = GoogleFonts.poppins(
      color: Colors.white.withValues(alpha: .75),
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    final amountStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 44,
      fontWeight: FontWeight.w700,
      letterSpacing: .5,
    );

    final labelStyle = GoogleFonts.poppins(
      color: Colors.white.withValues(alpha: .75),
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    final chipStyle = GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF3F5BD8), Color(0xFF7B4DDB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Monthly Spending", style: titleStyle),
              Flexible(
                child: FittedBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "+${percentChange.toStringAsFixed(1)}% VS Last Month",
                      style: chipStyle,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text("₹${totalSpending.toStringAsFixed(2)}", style: amountStyle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Daily Limit", style: labelStyle),
              Text(
                "₹${dailyUsed.toStringAsFixed(0)} / ₹${dailyLimit.toStringAsFixed(0)}",
                style: valueStyle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: .25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget progress(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF6D23DE), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Consumer<Taskprovider>(
        builder: (context, task, child) => Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YOUR PROGRESS",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${(task.todayPercent * 100).round()}%",
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      AutoSizeText(
                        "reached",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    "Almost there! ${task.todayTotal - task.todayCompleted} tasks left to\ncomplete your daily goal.",
                    style: GoogleFonts.poppins(
                      fontSize: screenwidth * 0.04,
                      color: Colors.black54,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CircularPercentIndicator(
              radius: 55,
              lineWidth: 10,
              percent: task.todayPercent,
              progressColor: task.percentagecolor(task.todayPercent),
              backgroundColor: Colors.grey.shade300,
              circularStrokeCap: CircularStrokeCap.round,
              center: Icon(
                Icons.flash_on,
                size: 35,
                color: task.percentagecolor(task.todayPercent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
