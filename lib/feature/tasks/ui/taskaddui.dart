import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/core/utils/snackbar.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:provider/provider.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({super.key});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "New Task",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Task Title",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 6),
              _inputField(
                controller: titleController,
                hint: "What needs to be done?",
              ),
              const SizedBox(height: 14),
              Text(
                "Description",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 6),
              _inputField(
                controller: descriptionController,
                hint: "Add more details...",
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Selector<Taskprovider, DateTime?>(
                      selector: (_, provider) => provider.selectedDate,
                      builder: (context, selectedDate, _) {
                        return _dateTimeButton(
                          text: selectedDate == null
                              ? "Select Date"
                              : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          icon: Icons.calendar_today,
                          onTap: () =>
                              context.read<Taskprovider>().pickDate(context),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Selector<Taskprovider, TimeOfDay?>(
                      selector: (_, provider) => provider.selectedTime,
                      builder: (context, selectedTime, _) {
                        return _dateTimeButton(
                          text: selectedTime == null
                              ? "Select Time"
                              : selectedTime.format(context),
                          icon: Icons.access_time,
                          onTap: () =>
                              context.read<Taskprovider>().pickTime(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                "Priority Level",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 10),
              Selector<Taskprovider, String>(
                selector: (_, provider) => provider.priority,
                builder: (context, priority, _) {
                  final priorities = ["low", "medium", "high"];
                  final controller = context.read<Taskprovider>();
                  return Row(
                    children: priorities.map((p) {
                      final isSelected = p == priority;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setPriority(p),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? controller.getPriorityColor(p)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              p.toUpperCase(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final addController = context.read<Taskprovider>();

                    if (titleController.text.trim().isEmpty) return;

                    try {
                      await addController.addTask(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                      if (!mounted) return;
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      Snackbardesign.showCustomSnackbar(
                        title: "Date Is Required",
                        subtitle: "Please Fill the Date",
                        backgroundColor: Color(0xFFFF9800),
                        icon: Icons.error_outline,
                      );
                    }
                  },
                  child: Text(
                    "Create Task",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.8),
        ),
        prefixIcon: const Icon(Icons.edit_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _dateTimeButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

void openTaskBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return const TaskBottomSheet();
    },
  );
}
