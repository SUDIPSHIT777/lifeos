import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:provider/provider.dart';

class Cardwidget {
  // ===================== MorningDetails Card ==============
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

  // ================ Proggress Card ====================
  Widget progressCard(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<Taskprovider>(
              builder: (context, taskprovider, child) => Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: CircularProgressIndicator(
                      value: taskprovider.todayPercent,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(
                        taskprovider.percentagecolor(taskprovider.todayPercent),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        "${(taskprovider.todayPercent * 100).round()}%",
                        style: GoogleFonts.poppins(
                          fontSize: screenwidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: taskprovider.percentagecolor(
                            taskprovider.todayPercent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        "DAILY GOAL",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Momentum is high",
              style: GoogleFonts.poppins(
                fontSize: screenwidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<Taskprovider>(
              builder: (context, taskprovider, child) => Text(
                "You've completed ${taskprovider.todayCompleted} of ${taskprovider.todayTotal} core objectives for the morning. Stay focused!",
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B3DF5), Color(0xFF8A7BFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Begin Flow",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
