import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/feature/dashboard/controller/weatherprovider.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:provider/provider.dart';

class Cardwidget {
  // ===================== MorningDetails Card ==============
  Widget morningdetails(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * .05,
            vertical: width * .055,
          ),
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
              /// LEFT
              Expanded(
                flex: 6,
                child: Consumer<Userprovider>(
                  builder: (context, time, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<Userprovider>(
                          builder: (context, value, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      "${value.gettime},",
                                      maxLines: 1,
                                      minFontSize: 10,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Image.asset(
                                    value.imagePath,
                                    width: width * .06,
                                    height: width * .06,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: width * .03),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            time.time,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: width * .13,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),

                        SizedBox(height: width * .02),

                        AutoSizeText(
                          time.date,
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(width: width * .04),

              /// RIGHT
              Expanded(
                flex: 3,
                child: Consumer<WeatherProvider>(
                  builder: (context, weather, child) {
                    if (weather.isLoading) {
                      return const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    if (weather.error != null) {
                      return const Center(
                        child: Text(
                          "Error",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final data = weather.weatherData;

                    if (data == null) {
                      return const Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          "${data['current']['temp_c']}°C",
                          maxLines: 1,
                          minFontSize: 16,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: width * .015),

                        AutoSizeText(
                          data['current']['condition']['text']
                              .toString()
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: .7),
                            fontWeight: FontWeight.w600,
                            letterSpacing: .8,
                          ),
                        ),

                        SizedBox(height: width * .02),

                        Image.network(
                          "https:${data['current']['condition']['icon']}",
                          width: width * .12,
                          height: width * .12,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.cloud_off,
                            color: Colors.white30,
                            size: width * .10,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final progressSize = (width * 0.38).clamp(110.0, 170.0);
        final percentFont = (width * 0.075).clamp(22.0, 34.0);
        final titleFont = (width * 0.06).clamp(18.0, 28.0);
        final bodyFont = (width * 0.038).clamp(12.0, 16.0);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: width * .05,
            vertical: width * .06,
          ),
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
                builder: (context, taskprovider, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: progressSize,
                        height: progressSize,
                        child: CircularProgressIndicator(
                          value: taskprovider.todayPercent,
                          strokeWidth: progressSize * .085,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(
                            taskprovider.percentagecolor(
                              taskprovider.todayPercent,
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child: SizedBox(
                          width: progressSize * .60,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${(taskprovider.todayPercent * 100).round()}%",
                                  style: GoogleFonts.poppins(
                                    fontSize: percentFont,
                                    fontWeight: FontWeight.bold,
                                    color: taskprovider.percentagecolor(
                                      taskprovider.todayPercent,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: progressSize * .03),

                              AutoSizeText(
                                "DAILY GOAL",
                                maxLines: 1,
                                minFontSize: 8,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: bodyFont,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: width * .06),

              AutoSizeText(
                "Momentum is high",
                maxLines: 1,
                minFontSize: 16,
                style: GoogleFonts.poppins(
                  fontSize: titleFont,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Consumer<Taskprovider>(
                builder: (context, taskprovider, child) {
                  return AutoSizeText(
                    "You've completed ${taskprovider.todayCompleted} of ${taskprovider.todayTotal} core objectives for the morning. Stay focused!",
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    minFontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: bodyFont,
                      height: 1.45,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),

              SizedBox(height: width * .07),

              SizedBox(
                width: double.infinity,
                height: (width * .14).clamp(48.0, 58.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B3DF5), Color(0xFF8A7BFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withValues(alpha: .3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AutoSizeText(
                      "Begin Flow",
                      maxLines: 1,
                      minFontSize: 14,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFont + 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
