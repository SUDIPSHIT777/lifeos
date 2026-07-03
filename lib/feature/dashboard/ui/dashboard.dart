// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/ai_assistant/widget/tilewidget.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/feature/dashboard/controller/weatherprovider.dart';
import 'package:lifeos/feature/dashboard/service/weather.dart';
import 'package:lifeos/feature/dashboard/ui/drawer.dart';
import 'package:lifeos/feature/dashboard/widget/buttonwidget.dart';
import 'package:lifeos/feature/dashboard/widget/cardwidget.dart';
import 'package:lifeos/feature/dashboard/widget/focustimer.dart';
import 'package:lifeos/feature/dashboard/widget/notes.dart';
import 'package:lifeos/feature/dashboard/widget/recenttask.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/ui/taskaddui.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final WeatherService weatherservice = WeatherService();
  final Buttonwidget buttonwidget = Buttonwidget();
  final Cardwidget cardwidget = Cardwidget();
  final Recenttask recenttask = Recenttask();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Userprovider>().loaduserdata();
      context.read<WeatherProvider>().fetchWeather();
      final provider = context.read<Taskprovider>();
      provider.getTasks().listen((_) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        surfaceTintColor: const Color(0xFFFFFFFF),
        titleSpacing: 2,
        backgroundColor: const Color(0xFFFCFCFD),
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.orangeAccent],
                    ),
                  ),
                  child: Image.asset("assets/logos.png", fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
        title: Text(
          "LIFEOS",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Consumer<Userprovider>(
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  value.showNotificationSnackbar();
                },
                child: Container(
                  height: screenheight * 0.05,
                  width: screenwidth * 0.11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    size: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff475467),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenwidth * 0.02),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00c247), width: 2),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset("assets/boy.png", fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
      drawer: const Drawer(child: ProfilePage()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hello ,",
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: screenwidth * 0.07,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  Consumer<Userprovider>(
                    builder: (context, value, child) => Text(
                      value.username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: screenwidth * 0.07,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Ready for your peak performance today?",
                overflow: TextOverflow.visible,
                maxLines: 2,
                style: GoogleFonts.poppins(
                  fontSize: screenwidth * 0.045,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7F8284),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  context.push('/dashboard/weatherpage');
                },
                child: cardwidget.morningdetails(context),
              ),
              const SizedBox(height: 15),
              sectionTitle("Progress"),
              const SizedBox(height: 15),
              cardwidget.progressCard(context),
              const SizedBox(height: 10),
              sectionTitle("Quick Action"),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.15,

                      children: [
                        /// ADD TASK
                        GestureDetector(
                          onTap: () => openTaskBottomSheet(context),

                          child: buttonwidget.button(
                            context,
                            titel: "Add Task",
                            icon: Icons.add_task_sharp,
                            backgroundcolor: const Color(0xFFDBEAFE),
                            iconcolor: const Color(0xFF2563EB),
                          ),
                        ),

                        /// FINANCE
                        buttonwidget.button(
                          context,
                          titel: "Log Finance",
                          icon: Icons.payments,
                          backgroundcolor: const Color(0xFFFFEDD5),
                          iconcolor: const Color(0xFFEA580C),
                        ),

                        /// HABIT
                        buttonwidget.button(
                          context,
                          titel: "Habit",
                          icon: Icons.fitness_center_sharp,
                          backgroundcolor: const Color(0xFFF3E8FF),
                          iconcolor: const Color(0xFF9333EA),
                        ),

                        /// NOTE
                        buttonwidget.button(
                          context,
                          titel: "New Note",
                          icon: Icons.note_alt,
                          backgroundcolor: const Color(0xFFD1FAE5),
                          iconcolor: const Color(0xFF059669),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              sectionTitle("Recent Task"),
              const SizedBox(height: 15),
              recenttask.recentTaskWidget(context),
              const SizedBox(height: 15),
              sectionTitle("Finance Management"),
              const SizedBox(height: 15),
              cardwidget.monthlySpendingCard(
                totalSpending: 3240.50,
                dailyUsed: 150,
                dailyLimit: 200,
                percentChange: 12.5,
              ),
              const SizedBox(height: 15),
              sectionTitle("Focus Mode"),
              const SizedBox(height: 15),
              const FocusTimer(),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sectionTitle("Recent Notes"),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "New Note",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff3D5CFF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              horizontalNotes([
                NoteModel(
                  title: "App Idea: Grocery...",
                  subtitle:
                      "Need to integrate with local supermarket APIs for real-time inventory tracking.",
                  time: "2 hours ago",
                ),
                NoteModel(
                  title: "Meeting Notes",
                  subtitle:
                      "Focus on AI integration. Users want a natural language interface.",
                  time: "Yesterday",
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
