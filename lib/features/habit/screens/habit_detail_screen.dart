import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../models/habit_model.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late HabitModel habit;

  @override
  void initState() {
    super.initState();
    habit = widget.habit;
  }

  String _getRepeatDaysText(List<int> repeatOn) {
    const weekdayNames = {
      0: 'Chủ nhật',
      DateTime.monday: 'Thứ 2',
      DateTime.tuesday: 'Thứ 3',
      DateTime.wednesday: 'Thứ 4',
      DateTime.thursday: 'Thứ 5',
      DateTime.friday: 'Thứ 6',
      DateTime.saturday: 'Thứ 7',
    };

    if (repeatOn.length == 7) return 'Mỗi ngày';
    if (repeatOn.isEmpty) return 'Không lặp lại';

    return repeatOn.map((day) => weekdayNames[day] ?? '').join(', ');
  }

  bool get isCompletedToday {
    final today = DateTime.now();
    return habit.completedDates.any((dateStr) {
      final date = DateTime.parse(dateStr);
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    });
  }

  void _markCompletedToday() {
    final todayStr = DateTime.now().toIso8601String().split('T').first;

    if (habit.completedDates.contains(todayStr)) {
      context.read<HabitBloc>().add(UndoCompleteHabit(habit));
    } else {
      context.read<HabitBloc>().add(CompleteHabit(habit));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
        backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<HabitBloc, HabitState>(
              builder: (context, state) {
                if (state is! HabitLoaded) return const SizedBox.shrink();

                final updatedHabit = state.habits.firstWhere(
                      (h) => h.id == habit.id,
                  orElse: () => habit,
                );

                return Text(
                  '🎯 Số ngày hoàn thành: ${updatedHabit.completedDates.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              '🔁 Lặp lại vào: ${_getRepeatDaysText(habit.repeatOn ?? [])}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '🗓 Bắt đầu từ: ${DateFormat.yMMMMd('vi').format(habit.startDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (habit.endDate != null) ...[
              Text(
                '🏁 Kết thúc vào: ${DateFormat.yMMMMd('vi').format(habit.endDate!)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
            ],

            Text('📖 Mô tả:', style: Theme.of(context).textTheme.titleMedium),
            Text(
              habit.description?.isNotEmpty == true
                  ? habit.description!
                  : 'Không có mô tả',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _markCompletedToday,
                  icon: Icon(
                    isCompletedToday ? Icons.check_circle : Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    isCompletedToday
                        ? 'Đã hoàn thành hôm nay'
                        : 'Hoàn thành hôm nay',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isCompletedToday
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    disabledForegroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Chỉnh sửa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
