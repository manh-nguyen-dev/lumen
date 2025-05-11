import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../../../core/theme/colors.dart';
import '../widgets/habit_grid_item_widget.dart';
import '../widgets/habit_list_item_widget.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    context.read<HabitBloc>().add(LoadHabits());
  }

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
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HabitError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is HabitLoaded) {
            final habits = state.habits;

            if (habits.isEmpty) {
              return const Center(child: Text('Không có thói quen nào.'));
            }

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

          return const Center(child: Text('No habits found.'));
        },
      ),
    );
  }
}
