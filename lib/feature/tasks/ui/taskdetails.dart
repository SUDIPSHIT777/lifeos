import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/model/taskmodel.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/feature/tasks/controller/allupdatefunction.dart';
import 'package:lifeos/feature/tasks/widget/datetimecard.dart';

class Taskdetails extends StatefulWidget {
  final TaskModel alltaskdetails;
  const Taskdetails({super.key, required this.alltaskdetails});

  @override
  State<Taskdetails> createState() => _TaskdetailsState();
}

class _TaskdetailsState extends State<Taskdetails> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.alltaskdetails.title);
    descController = TextEditingController(text: widget.alltaskdetails.desc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DateTimeProvider>().setInitial(
        widget.alltaskdetails.date,
        widget.alltaskdetails.time,
      );
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.read<Taskprovider>();
    final priorityColor = taskProvider.getPriorityColor(
      widget.alltaskdetails.priority,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(
          "Task Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ================= CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Task title...",
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// PRIORITY CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.alltaskdetails.priority.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// DESCRIPTION
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Add description...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ================= Date + Time =================
                    Consumer<DateTimeProvider>(
                      builder: (context, dateProvider, _) {
                        return Row(
                          children: [
                            Expanded(
                              child: buildDateTimeCard(
                                icon: Icons.calendar_today,
                                label: "Date",
                                value: dateProvider.formatDate(),
                                onTap: () => dateProvider.pickDate(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: buildDateTimeCard(
                                icon: Icons.access_time,
                                label: "Time",
                                value: dateProvider.formatTime(),
                                onTap: () => dateProvider.pickTime(context),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CupertinoSwitch(
                          value: widget.alltaskdetails.isCompleted,
                          activeTrackColor: Colors.green,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// ================= Delete =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  await taskProvider.deletetask(widget.alltaskdetails.id);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete Task",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  final dateProvider = context.read<DateTimeProvider>();

                  await taskProvider.updatetask(
                    taskid: widget.alltaskdetails.id,
                    title: titleController.text.trim(),
                    description: descController.text.trim(),
                    date: dateProvider.selectedDate,
                    time: dateProvider.selectedTime,
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "Update Task",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
