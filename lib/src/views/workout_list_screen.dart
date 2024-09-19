import 'package:fitnessapp/src/providers/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout List'),
      ),
      body: workouts.isEmpty
          ? const Center(child: Text('No Workouts'))
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(
                      'Workout on ${workout.date.toLocal().toIso8601String()}'),
                  onTap: () {
                    ref.read(editingWorkoutProvider.notifier).state = workout;
                    ref.read(editingWorkoutIndexProvider.notifier).state =
                        index;
                    context.push('/workout');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(workoutListProvider.notifier)
                          .removeWorkout(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(editingWorkoutProvider.notifier).state = null;
          ref.read(editingWorkoutIndexProvider.notifier).state = -1;
          context.push('/workout');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
