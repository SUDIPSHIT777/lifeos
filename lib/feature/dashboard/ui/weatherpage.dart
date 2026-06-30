import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/weatherprovider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Weatherpage extends StatefulWidget {
  const Weatherpage({super.key});

  @override
  State<Weatherpage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          "Weather Details",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.055,
          ),
        ),
      ),

      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Text(
                  provider.error!,
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            }

            if (provider.weatherData == null) {
              return Center(
                child: Text("No Weather Data", style: GoogleFonts.poppins()),
              );
            }

            final data = provider.weatherData!;
            final current = data['current'];
            final location = data['location'];
            final advice = provider.weatherAdvice;

            return RefreshIndicator(
              onRefresh: provider.refresh,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: 20,
                ),

                children: [
                  /// LOCATION
                  Text(
                    location['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: width * 0.075,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${location['region']}, ${location['country']}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: width * 0.038,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// WEATHER ANIMATION CARD
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        /// ANIMATION
                        Container(
                          height: height * 0.28,
                          width: double.infinity,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: advice!['color'].withOpacity(0.08),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),

                            child: Lottie.asset(
                              advice['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// MESSAGE
                        Text(
                          advice['message'],
                          textAlign: TextAlign.center,

                          style: GoogleFonts.poppins(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// CONDITION CHIP
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: advice['color'].withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Text(
                            "${current['temp_c']}°C • ${current['condition']['text']}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.poppins(
                              color: advice['color'],
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// CURRENT WEATHER CARD
                  Container(
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        /// ICON
                        Container(
                          width: width * 0.25,
                          height: width * 0.25,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.withValues(alpha: 0.08),
                          ),

                          child: Image.network(
                            "https:${current['condition']['icon']}",
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// TEMP
                        FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            "${current['temp_c']}°C",

                            style: GoogleFonts.poppins(
                              fontSize: width * 0.14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// CONDITION
                        Text(
                          current['condition']['text'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: GoogleFonts.poppins(
                            fontSize: width * 0.045,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// FEELS LIKE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Text(
                            "Feels like ${current['feelslike_c']}°C",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// TITLE
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 24,

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          "Overview Statistics",

                          style: GoogleFonts.poppins(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  /// STATS
                  statsCard(
                    context: context,
                    title: "Humidity",
                    value: "${current['humidity']}%",
                    subtitle: "Current humidity level",

                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),

                    icon: Icons.water_drop_rounded,
                  ),

                  const SizedBox(height: 18),

                  statsCard(
                    context: context,
                    title: "Wind Speed",
                    value: "${current['wind_kph']} km/h",
                    subtitle: "Wind flow speed",

                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B894), Color(0xFF00997A)],
                    ),

                    icon: Icons.air_rounded,
                  ),

                  const SizedBox(height: 18),

                  statsCard(
                    context: context,
                    title: "UV Index",
                    value: "${current['uv']}",
                    subtitle: "Sun exposure level",

                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B51E0), Color(0xFF7B2CBF)],
                    ),

                    icon: Icons.sunny,
                  ),

                  const SizedBox(height: 18),

                  statsCard(
                    context: context,
                    title: "Feels Like",
                    value: "${current['feelslike_c']}°C",
                    subtitle: "Perceived temperature",

                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                    ),

                    icon: Icons.thermostat_rounded,
                  ),

                  const SizedBox(height: 35),

                  /// BUTTON
                  InkWell(
                    onTap: () => Navigator.pop(context),

                    child: Container(
                      height: 58,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),

                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B3DF5), Color(0xFF7F67FF)],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text(
                          "Begin Flow",

                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: width * 0.042,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget statsCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required LinearGradient gradient,
    required IconData icon,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,

      constraints: const BoxConstraints(minHeight: 150),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: Icon(
              icon,
              size: width * 0.18,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),

          /// CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: [
              /// TOP ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    width: width * 0.11,
                    height: width * 0.11,

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Icon(icon, color: Colors.white, size: width * 0.05),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// VALUE
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,

                child: Text(
                  value,
                  maxLines: 1,

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: width * 0.085,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// SUBTITLE
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: width * 0.032,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
