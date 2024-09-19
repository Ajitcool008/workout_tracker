import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutListProvider =
    StateNotifierProvider<WorkoutListNotifier, List<Workout>>((ref) {
  return WorkoutListNotifier();
});

final editingWorkoutProvider = StateProvider<Workout?>((ref) => null);
final editingWorkoutIndexProvider = StateProvider<int>((ref) => -1);

class WorkoutListNotifier extends StateNotifier<List<Workout>> {
  WorkoutListNotifier() : super([]);

  void addWorkout(Workout workout) {
    state = [...state, workout];
  }

  void removeWorkout(int index) {
    state = [...state]..removeAt(index);
  }

  void editWorkout(int index, Workout workout) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) workout else state[i],
    ];
  }
}
