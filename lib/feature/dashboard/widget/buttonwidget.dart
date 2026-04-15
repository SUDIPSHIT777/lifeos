import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/provider.dart';
import 'package:provider/provider.dart';

class Buttonwidget {
  // ========================== Button ==============================
  Widget button({
    required String titel,
    required IconData icon,
    required Color? backgroundcolor,
    required Color? iconcolor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: backgroundcolor ?? const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconcolor ?? const Color(0xff3B82F6),
            fontWeight: FontWeight.w500,
            size: 27.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          titel,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xff6B7280),
          ),
        ),
      ],
    );
  }

  // ======================== Finance Card Details===================
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
}
