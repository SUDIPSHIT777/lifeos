// ignore_for_file: use_build_context_synchronously
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/dashboard/controller/provider.dart';
import 'package:lifeos/feature/dashboard/service/weather.dart';
import 'package:lifeos/feature/dashboard/ui/drawer.dart';
import 'package:lifeos/feature/dashboard/widget/buttonwidget.dart';
import 'package:lifeos/feature/dashboard/widget/notes.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/ui/taskaddui.dart';
import 'package:lifeos/model/userdatabase.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final WeatherService weatherservice = WeatherService();
  final userdatabase = Userdatabase();
  final buttonwidget = Buttonwidget();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Userprovider>().loaduserdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F8),
      appBar: AppBar(
        surfaceTintColor: Color(0xFFFFFFFF),
        titleSpacing: 2,
        backgroundColor: Color(0xFFFCFCFD),
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
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
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF00c247), width: 2),
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
      drawer: Drawer(child: ProfilePage()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  color: Color(0xFF7F8284),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 15),
              buttonwidget.morningdetails(context),
              const SizedBox(height: 15),
              Container(
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
              ),
              // const SizedBox(height: 10),
              // Center(child: AIModel()),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quick Action",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 0.1,
                color: Color(0XFFFFFFFF),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => openTaskBottomSheet(context),
                        child: buttonwidget.button(
                          titel: "Add Task",
                          icon: Icons.add_task_sharp,
                          backgroundcolor: Color(0xFFE2E7F6),
                          iconcolor: Color(0xFF305EE8),
                        ),
                      ),
                      buttonwidget.button(
                        titel: "Log Finance",
                        icon: Icons.payments,
                        backgroundcolor: Color(0xFFF6E9E0),
                        iconcolor: Color(0xFFF97316),
                      ),
                      buttonwidget.button(
                        titel: "Habit",
                        icon: Icons.fitness_center_sharp,
                        backgroundcolor: Color(0xFFEBE6F7),
                        iconcolor: Color(0xFF8B5CF6),
                      ),
                      buttonwidget.button(
                        titel: "New Note",
                        icon: Icons.note_alt,
                        backgroundcolor: Color(0xFFDFF0EB),
                        iconcolor: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              buttonwidget.monthlySpendingCard(
                totalSpending: 3240.50,
                dailyUsed: 150,
                dailyLimit: 200,
                percentChange: 12.5,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Note",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
