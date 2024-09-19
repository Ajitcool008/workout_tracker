import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutSetProvider =
    StateNotifierProvider<WorkoutSetNotifier, List<WorkoutSet>>((ref) {
  return WorkoutSetNotifier();
});

class WorkoutSetNotifier extends StateNotifier<List<WorkoutSet>> {
  WorkoutSetNotifier() : super([]);

  // Add a set
  void addSet(WorkoutSet set) {
    state = [...state, set];
  }

  // Remove a set by index
  void removeSet(int index) {
    state = [...state]..removeAt(index);
  }

  // Clear all sets
  void clearSets() {
    state = [];
  }

  // Update sets when editing a workout
  void updateSets(List<WorkoutSet> sets) {
    state = sets;
  }

  // Edit a set by index
  void updateSet(int index, WorkoutSet updatedSet) {
    final updatedSets = [...state];
    if (index >= 0 && index < updatedSets.length) {
      updatedSets[index] = updatedSet; // Update the specific set
      state = updatedSets;
    }
  }
}
