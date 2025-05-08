import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/habit_model.dart';
import '../../../core/theme/colors.dart';
import '../widgets/habit_grid_item_widget.dart';
import '../widgets/habit_list_item_widget.dart';
import '../../../core/constants/app_constants.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
      appBar: AppBar(
        title: const Text('Thói quen của bạn'),
        backgroundColor: AppColors.lightPrimary.withValues(alpha: .2),
        actions: [
          IconButton(
            icon: Icon(
              isGridView ? LucideIcons.layers : LucideIcons.layoutGrid,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<HabitModel>>(
        future: _loadHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có thói quen nào.'));
          } else {
            final habits = snapshot.data!;

            if (isGridView) {
              return MasonryGridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return HabitGridItemWidget(habit: habit);
                },
              );
            } else {
              return ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return HabitListItemWidget(habit: habit);
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<List<HabitModel>> _loadHabits() async {
    final habitBox = await Hive.openBox<HabitModel>(AppConstants.habitsBox);
    return habitBox.values.toList();
  }
}
