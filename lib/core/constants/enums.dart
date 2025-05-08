import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 2)
enum NoteType {
  @HiveField(0)
  normal,

  @HiveField(1)
  reminder,

  @HiveField(2)
  task,

  @HiveField(3)
  idea,
}

extension NoteTypeLabel on NoteType {
  String get label {
    switch (this) {
      case NoteType.normal:
        return 'Thường';
      case NoteType.reminder:
        return 'Nhắc nhở';
      case NoteType.task:
        return 'Công việc';
      case NoteType.idea:
        return 'Ý tưởng';
    }
  }

  IconData get icon {
    switch (this) {
      case NoteType.normal:
        return Icons.note_outlined;
      case NoteType.reminder:
        return Icons.alarm;
      case NoteType.task:
        return Icons.check_circle_outline;
      case NoteType.idea:
        return Icons.lightbulb_outline;
    }
  }
}

final List<NoteType> noteTypes = NoteType.values;


@HiveType(typeId: 5)
enum Frequent {
  @HiveField(0)
  daily,

  @HiveField(1)
  weekly,

  @HiveField(2)
  monthly,

  @HiveField(3)
  yearly,
}

extension FrequentExtension on Frequent {
  String get label {
    switch (this) {
      case Frequent.daily:
        return 'Hàng ngày';
      case Frequent.weekly:
        return 'Hàng tuần';
      case Frequent.monthly:
        return 'Hàng tháng';
      case Frequent.yearly:
        return 'Hàng năm';
    }
  }
}

