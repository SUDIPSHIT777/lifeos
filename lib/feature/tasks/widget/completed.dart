import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/ui/taskdetails.dart';
import 'package:lifeos/feature/tasks/widget/deletetask.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Taskprovider>(
      builder: (context, taskprovider, child) {
        final completedTasks = taskprovider.tasks
            .where((task) => task.isCompleted)
            .toList();
        if (completedTasks.isEmpty) {
          return Center(
            child: Lottie.asset(
              "assets/taskcompleted.json",
              alignment: Alignment.center,
              height: 300,
            ),
          );
        }
        return ListView.builder(
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Taskdetails(alltaskdetails: task),
                ),
              ),
              onLongPress: () => confirmDelete(context, task.id),
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
                        onChanged: (_) {
                          taskprovider.toggleTask(task);
                          !task.isCompleted ? taskprovider.playAudio() : null;
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Image.asset("assets/calendar.png", scale: 25),
                              const SizedBox(width: 5),
                              Text(
                                task.date != null
                                    ? "${task.date!.day}/${task.date!.month}/${task.date!.year}"
                                    : "No date",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Image.asset("assets/waste.png", scale: 25),
                              const SizedBox(width: 5),
                              Text(
                                task.time?.format(context) ?? "No time",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: taskcolor
                                .getPriorityColor(task.priority)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                taskcolor.getPriorityIcon(task.priority),
                                size: 14,
                                color: taskcolor.getPriorityColor(
                                  task.priority,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.priority.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: taskcolor.getPriorityColor(
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
        );
      },
    );
  }
}
