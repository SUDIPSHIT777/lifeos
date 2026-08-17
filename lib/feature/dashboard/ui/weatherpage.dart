import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFCFCFD),
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          "Weather Details",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
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
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (provider.weatherData == null) {
              return const Center(
                child: Text("No Weather Data", style: TextStyle()),
              );
            }

            final data = provider.weatherData!;
            final current = data['current'];
            final location = data['location'];
            final advice = provider.weatherAdvice;
            final stats = [
              {
                "title": "Humidity",
                "value": "${current['humidity']}%",
                "subtitle": "Current humidity level",
                "icon": Icons.water_drop_outlined,
              },
              {
                "title": "Wind Speed",
                "value": "${current['wind_kph']} km/h",
                "subtitle": "Wind flow speed",
                "icon": Icons.air,
              },
              {
                "title": "UV Index",
                "value": "${current['uv']}",
                "subtitle": "Sun exposure level",
                "icon": Icons.wb_sunny_outlined,
              },
              {
                "title": "Feels Like",
                "value": "${current['feelslike_c']}°C",
                "subtitle": "Perceived temperature",
                "icon": Icons.thermostat_outlined,
              },
            ];
            return RefreshIndicator(
              onRefresh: provider.refresh,
              color: Colors.black,
              backgroundColor: Colors.white,
              child: ListView(
                physics: BouncingScrollPhysics(),
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

                    style: TextStyle(
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

                    style: TextStyle(
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

                          style: TextStyle(
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

                            style: TextStyle(
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

                            style: TextStyle(
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

                          style: TextStyle(
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

                            style: TextStyle(
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

                          style: TextStyle(
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.15,
                        ),
                    itemBuilder: (context, index) {
                      final item = stats[index];

                      return statsCard(
                        context: context,
                        title: item["title"] as String,
                        value: item["value"] as String,
                        subtitle: item["subtitle"] as String,
                        icon: item["icon"] as IconData,
                      );
                    },
                  ),
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
    required IconData icon,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        // Responsive padding
        final padding = (screenWidth * 0.04).clamp(10.0, 16.0);

        // Responsive icon container
        final iconContainerSize = (cardWidth * 0.22).clamp(32.0, 42.0);

        // Responsive icon
        final iconSize = (cardWidth * 0.12).clamp(18.0, 22.0);

        // Responsive text sizes
        final titleSize = (cardWidth * 0.075).clamp(12.0, 14.0);

        final valueSize = (cardWidth * 0.14).clamp(18.0, 24.0);

        final subtitleSize = (cardWidth * 0.06).clamp(10.0, 11.0);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              (screenWidth * 0.03).clamp(10.0, 14.0),
            ),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICON
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF334155),
                  size: iconSize,
                ),
              ),

              /// SPACE
              SizedBox(height: (cardWidth * 0.07).clamp(8.0, 12.0)),

              /// TITLE
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              /// SPACE
              SizedBox(height: (cardWidth * 0.02).clamp(3.0, 5.0)),

              /// VALUE
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: valueSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ),

              /// SUBTITLE
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
