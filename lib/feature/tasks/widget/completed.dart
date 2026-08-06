import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/widget/deletetask.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Consumer<Taskprovider>(
      builder: (context, taskprovider, child) {
        final completedTasks = taskprovider.tasks
            .where((task) => task.isCompleted)
            .toList();

        if (completedTasks.isEmpty) {
          return Center(
            child: Lottie.asset(
              "assets/taskcompleted.json",
              width: width * 0.75,
              height: width * 0.75,
              fit: BoxFit.contain,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: width * 0.02,
          ),
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];

            return GestureDetector(
              onTap: () => context.pushNamed('taskDetails', extra: task),
              onLongPress: () => confirmDelete(context, task.id),
              child: Container(
                margin: EdgeInsets.only(bottom: width * 0.03),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.035,
                  vertical: width * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.04),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: width < 360 ? 1.0 : 1.15,
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          taskprovider.toggleTask(task);
                          if (!task.isCompleted) {
                            taskprovider.playAudio();
                          }
                        },
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(width: width * 0.025),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),

                          SizedBox(height: width * 0.015),

                          Wrap(
                            spacing: width * 0.02,
                            runSpacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                "assets/calendar.png",
                                width: width * 0.04,
                              ),
                              Text(
                                task.date != null
                                    ? "${task.date!.day}/${task.date!.month}/${task.date!.year}"
                                    : "No date",
                                style: TextStyle(
                                  fontSize: width * 0.03,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Image.asset(
                                "assets/waste.png",
                                width: width * 0.04,
                              ),

                              Text(
                                task.time?.format(context) ?? "No time",
                                style: TextStyle(
                                  fontSize: width * 0.03,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: width * 0.02),

                    Consumer<Taskprovider>(
                      builder: (context, taskcolor, _) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                            vertical: width * 0.015,
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
                                size: width * 0.035,
                                color: taskcolor.getPriorityColor(
                                  task.priority,
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                task.priority.toUpperCase(),
                                style: TextStyle(
                                  fontSize: width * 0.026,
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
