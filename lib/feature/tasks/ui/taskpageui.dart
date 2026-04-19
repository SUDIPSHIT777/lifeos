import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/feature/dashboard/controller/provider.dart';
import 'package:lifeos/feature/dashboard/ui/drawer.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/ui/taskaddui.dart';
import 'package:lifeos/feature/tasks/ui/taskdetails.dart';
import 'package:lifeos/feature/tasks/widget/completed.dart';
import 'package:lifeos/feature/tasks/widget/taskpersentage.dart';
import 'package:lifeos/model/taskmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Taskpageui extends StatefulWidget {
  const Taskpageui({super.key});

  @override
  State<Taskpageui> createState() => _TaskpageuiState();
}

class _TaskpageuiState extends State<Taskpageui>
    with SingleTickerProviderStateMixin {
  final taskpersentage = Taskpersentage();
  late TabController _tabController;

  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // ================== PROGRESS ==================
            StreamBuilder<List<TaskModel>>(
              stream: context.read<Taskprovider>().getTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return taskpersentage.dailyProgressCard(
                    completed: 0,
                    total: 0,
                    percent: 0,
                  );
                }

                final tasks = snapshot.data!;

                bool isToday(DateTime date) {
                  final now = DateTime.now();
                  return date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;
                }

                final todayTasks = tasks.where((task) {
                  return isToday(task.date ?? task.createdAt);
                }).toList();

                final todayTotal = todayTasks.length;
                final todayCompleted = todayTasks
                    .where((t) => t.isCompleted)
                    .length;

                final todayPercent = todayTotal == 0
                    ? 0
                    : todayCompleted / todayTotal;

                // ✅ FIX snackbar spam
                if (todayPercent >= 1.0 && !_snackbarShown) {
                  _snackbarShown = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Snackbardesign.showCustomSnackbar(
                      title: "Task Completed",
                      subtitle: "Congratulations You completed your task",
                      backgroundColor: Color(0xFF00c247),
                      icon: Icons.download_done_rounded,
                    );
                  });
                }

                return taskpersentage.dailyProgressCard(
                  completed: todayCompleted,
                  total: todayTotal,
                  percent: todayPercent.toDouble(),
                );
              },
            ),

            const SizedBox(height: 18),

            // ================== TAB BAR ==================
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Color(0xff4F46E5), Color(0xff7C3AED)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff7C3AED).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: -15),
                tabs: const [
                  Tab(text: "All Tasks"),
                  Tab(text: "Completed"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<List<TaskModel>>(
                    stream: context.read<Taskprovider>().getTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 12),
                              Flexible(
                                child: Lottie.asset(
                                  "assets/Man with task list.json",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final tasks = snapshot.data!
                          .where((task) => !task.isCompleted)
                          .toList();
                      final taskprovider = context.read<Taskprovider>();
                      final groupedTasks = taskprovider.groupTasks(tasks);
                      final dates = groupedTasks.keys.toList();
                      dates.sort((a, b) => a.compareTo(b));

                      return ListView.builder(
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final date = dates[index];
                          final dateTasks = groupedTasks[date]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                taskprovider.formatDate(date),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: dateTasks.length,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final task = dateTasks[index];

                                  // ✅ KEEP YOUR UI EXACTLY SAME BELOW
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Taskdetails(alltaskdetails: task),
                                      ),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.2,
                                            child: Checkbox(
                                              value: task.isCompleted,
                                              onChanged: (_) async {
                                                await taskprovider.toggleTask(
                                                  task,
                                                );
                                                if (task.isCompleted) {
                                                  taskprovider.playAudio();
                                                }
                                              },
                                              checkColor: Colors.white,
                                              activeColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          // ✅ YOUR ORIGINAL UI UNTOUCHED
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: task.isCompleted
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                    color: task.isCompleted
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/calendar.png",
                                                      scale: 25,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      task.date != null
                                                          ? "${task.date!.day}/${task.date!.month}/${task.date!.year}"
                                                          : "No date",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Image.asset(
                                                      "assets/waste.png",
                                                      scale: 25,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      task.time?.format(
                                                            context,
                                                          ) ??
                                                          "No time",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          Consumer<Taskprovider>(
                                            builder: (context, taskcolor, _) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: taskcolor
                                                      .getPriorityColor(
                                                        task.priority,
                                                      )
                                                      .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      taskcolor.getPriorityIcon(
                                                        task.priority,
                                                      ),
                                                      size: 14,
                                                      color: taskcolor
                                                          .getPriorityColor(
                                                            task.priority,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      task.priority
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: taskcolor
                                                            .getPriorityColor(
                                                              task.priority,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Completed(),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1976ED),
        onPressed: () {
          openTaskBottomSheet(context);
        },
        child: Icon(Icons.add_circle, size: 28, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
