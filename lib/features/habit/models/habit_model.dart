import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:lumen/core/constants/enums.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 3)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final int color;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final Frequent frequent;

  @HiveField(6)
  final TimeOfDay? dailyReminder;

  @HiveField(7)
  final List<int>? repeatOn;

  @HiveField(8)
  final DateTime startDate;

  @HiveField(9)
  final DateTime? endDate;

  @HiveField(10)
  final List<String> completedDates;

  HabitModel({
    String? id,
    required this.title,
    required this.icon,
    required this.color,
    this.description,
    required this.frequent,
    this.dailyReminder,
    this.repeatOn,
    DateTime? startDate,
    this.endDate,
    this.completedDates = const [],
  }) : id = id ?? Uuid().v4(),
       startDate = startDate ?? DateTime.now();

  Color getColor() {
    return Color(color);
  }
}
