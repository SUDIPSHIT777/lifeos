import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String title;
  final String categoryTag;
  final int iconCode;
  final int colorValue;
  bool isCompleted;
  int streak;
  List<String> completedDates;
  final DateTime createdAt;

  static const List<IconData> availableIcons = [
    Icons.check_circle_outline,
    Icons.self_improvement,
    Icons.water_drop,
    Icons.menu_book,
    Icons.fitness_center,
    Icons.directions_run,
    Icons.bedtime,
    Icons.code,
    Icons.local_cafe,
    Icons.music_note,
    Icons.directions_bike,
    Icons.favorite_outline,
    Icons.star_outline,
    Icons.alarm,
    Icons.pets,
    Icons.spa,
  ];

  HabitModel({
    required this.id,
    required this.title,
    this.categoryTag = 'Daily',
    this.iconCode = 0xe156,
    this.colorValue = 0xFF6366F1,
    this.isCompleted = false,
    this.streak = 0,
    List<String>? completedDates,
    DateTime? createdAt,
  })  : completedDates = completedDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  Color get color => Color(colorValue);

  IconData get icon {
    for (final iconData in availableIcons) {
      if (iconData.codePoint == iconCode) {
        return iconData;
      }
    }
    return Icons.check_circle_outline;
  }

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HabitModel(
      id: doc.id,
      title: data['title'] ?? '',
      categoryTag: data['categoryTag'] ?? 'Daily',
      iconCode: data['iconCode'] ?? 0xe156,
      colorValue: data['colorValue'] ?? 0xFF6366F1,
      isCompleted: data['isCompleted'] ?? false,
      streak: data['streak'] ?? 0,
      completedDates: List<String>.from(data['completedDates'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'categoryTag': categoryTag,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'isCompleted': isCompleted,
      'streak': streak,
      'completedDates': completedDates,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  HabitModel copyWith({
    String? id,
    String? title,
    String? categoryTag,
    int? iconCode,
    int? colorValue,
    bool? isCompleted,
    int? streak,
    List<String>? completedDates,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryTag: categoryTag ?? this.categoryTag,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
      completedDates: completedDates ?? List.from(this.completedDates),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
