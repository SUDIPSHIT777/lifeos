import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/model/taskmodel.dart';
import 'package:provider/provider.dart';

class Taskdetails extends StatelessWidget {
  final TaskModel alltaskdetails;
  const Taskdetails({super.key, required this.alltaskdetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F8),
      appBar: AppBar(
        surfaceTintColor: Color(0xFFFFFFFF),
        titleSpacing: 2,
        backgroundColor: Color(0xFFFCFCFD),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(
          "Task Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Consumer<Taskprovider>(
              builder: (context, taskcolor, child) => Container(
                width: 150,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: taskcolor
                      .getPriorityColor(alltaskdetails.priority)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        taskcolor.getPriorityIcon(alltaskdetails.priority),
                        size: 20,
                        color: taskcolor.getPriorityColor(taskcolor.priority),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        taskcolor.priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: taskcolor.getPriorityColor(taskcolor.priority),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
