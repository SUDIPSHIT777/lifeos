import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/feature/habit/controller/habitprovider.dart';
import 'package:lifeos/model/habitmodel.dart';

class AddHabitModal extends StatefulWidget {
  const AddHabitModal({super.key});

  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String _categoryTag = 'Daily';
  int _selectedColor = 0xFF6366F1; // Minimal Indigo
  int _selectedIconCode = HabitModel.availableIcons.first.codePoint;

  final List<int> _colorOptions = [
    0xFF6366F1, // Indigo
    0xFF2563EB, // Blue
    0xFF10B981, // Emerald Green
    0xFFF59E0B, // Amber
    0xFFEC407A, // Pink
    0xFF8B5CF6, // Purple
  ];

  final List<String> _tagOptions = [
    'Daily',
    'Morning',
    'Evening',
    'Weekly',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<HabitProvider>().addHabit(
            title: _titleController.text.trim(),
            categoryTag: _categoryTag,
            iconCode: _selectedIconCode,
            colorValue: _selectedColor,
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Habit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title Field
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g. Read 20 pages',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Category Tag
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _tagOptions.map((tag) {
                  final isSelected = _categoryTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _categoryTag = tag);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Icon Selection
              const Text(
                'Choose Icon',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: HabitModel.availableIcons.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final icon = HabitModel.availableIcons[index];
                    final isSelected = _selectedIconCode == icon.codePoint;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIconCode = icon.codePoint),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(_selectedColor).withValues(alpha: 0.15)
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Color(_selectedColor), width: 2)
                              : null,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Color(_selectedColor) : Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Color Selection
              const Text(
                'Color Accent',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colorOptions.map((colorHex) {
                  final isSelected = _selectedColor == colorHex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = colorHex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(colorHex),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(_selectedColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Habit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
