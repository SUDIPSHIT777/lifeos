import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/model/taskmodel.dart';
import 'package:provider/provider.dart';

class Recenttask {
  Widget recentTaskWidget(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: context.read<Taskprovider>().getTasks(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),

              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF3C38),
                  Color(0xFFFF8C42),
                  Color(0xFFFFD166),
                ],
              ),
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.task_alt_rounded,
                  size: 32,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  "No Tasks Yet",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        final allTasks = snapshot.data!;

        final tasks = allTasks.where((task) => !task.isCompleted).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        /// ALL TASK COMPLETED
        if (allTasks.isNotEmpty && tasks.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),

              gradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF64DD17)],
              ),
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.done_all_rounded,
                  size: 32,
                  color: Colors.white,
                ),

                const SizedBox(height: 12),

                Text(
                  "All Tasks Completed",

                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: tasks.take(3).map((task) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context
                          .read<Taskprovider>()
                          .getPriorityColor(task.priority)
                          .withValues(alpha: 0.4),
                    ),
                    child: Icon(
                      context.read<Taskprovider>().getPriorityIcon(
                        task.priority,
                      ),
                      color: context.read<Taskprovider>().getPriorityColor(
                        task.priority,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          task.desc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    task.priority.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.read<Taskprovider>().getPriorityColor(
                        task.priority,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
