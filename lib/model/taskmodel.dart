import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String desc;
  final DateTime? date;
  final TimeOfDay? time;
  final String priority;
  final DateTime createdAt;
  bool isCompleted;
  TaskModel({
    required this.id,
    required this.title,
    required this.desc,
    this.date,
    this.time,
    required this.priority,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    TimeOfDay? parsedTime;

    if (data['time'] != null) {
      final parts = data['time'].split(':');
      parsedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      desc: data['desc'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      time: parsedTime,
      priority: data['priority'] ?? 'low',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
