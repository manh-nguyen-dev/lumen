import 'package:hive/hive.dart';

part 'timer_history_model.g.dart';

@HiveType(typeId: 1)
class TimerHistoryModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int minutes;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime completedAt;

  TimerHistoryModel({
    required this.id,
    required this.minutes,
    required this.startTime,
    required this.completedAt,
  });
}
