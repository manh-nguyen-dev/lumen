import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/routes/routes.dart';
import '../../../core/constants/week_days.dart';
import '../models/habit_model.dart';

class HabitListItemWidget extends StatelessWidget {
  final HabitModel habit;

  const HabitListItemWidget({super.key, required this.habit});

  IconData getIconFromString(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return LucideIcons.activity;
      case 'book':
        return LucideIcons.graduationCap;
      case 'calendar_today':
        return LucideIcons.calendarDays;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.habitDetail, extra: habit);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  getIconFromString(habit.icon),
                  color: habit.getColor(),
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (habit.description != null)
                        Text(
                          habit.description!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${habit.completedDates.length} ngày',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (dayIndex) {
                final isActive = habit.repeatOn?.contains(dayIndex) ?? false;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? habit.getColor() : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    weekDays[dayIndex],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Bắt đầu: ${_formatDate(habit.startDate)}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (habit.endDate != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.flag, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Kết thúc: ${_formatDate(habit.endDate!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
