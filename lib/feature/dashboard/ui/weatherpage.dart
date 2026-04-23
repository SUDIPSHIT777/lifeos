import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        child: SafeArea(
          child: Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
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
                  child: Text(
                    "No Data",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                );
              }

              final data = provider.weatherData!;
              final current = data['current'];
              final location = data['location'];
              final advice = provider.weatherAdvice;

              return RefreshIndicator(
                onRefresh: provider.refresh,
                color: Colors.blueAccent,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      "${location['name']}, ${location['region']}, ${location['country']}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: advice!['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Lottie.asset(
                                advice['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(
                            advice['message'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: advice['color'],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Temp: ${current['temp_c']}°C • ${current['condition']['text']}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              "https:${current['condition']['icon']}",
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${current['temp_c']}°C",
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            current['condition']['text'],
                            style: GoogleFonts.poppins(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 📊 DATA GRID
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      children: [
                        weatherCard(
                          "Humidity",
                          "${current['humidity']}%",
                          Colors.blue,
                        ),
                        weatherCard(
                          "Wind",
                          "${current['wind_kph']} km/h",
                          Colors.teal,
                        ),
                        weatherCard(
                          "Feels Like",
                          "${current['feelslike_c']}°C",
                          Colors.orange,
                        ),
                        weatherCard(
                          "UV Index",
                          "${current['uv']}",
                          Colors.purple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget weatherCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
