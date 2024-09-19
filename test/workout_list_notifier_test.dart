import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:fitnessapp/src/providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WorkoutListNotifier workoutListNotifier;
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    workoutListNotifier = container.read(workoutListProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('WorkoutListNotifier Tests', () {
    test('Initial state should be empty', () {
      expect(workoutListNotifier.state, []);
    });

    test('Add a workout should add to the list', () {
      final workout = Workout(date: DateTime.now(), sets: []);

      workoutListNotifier.addWorkout(workout);

      expect(workoutListNotifier.state.length, 1);
      expect(workoutListNotifier.state[0], workout);
    });

    test('Remove a workout should remove workout at the correct index', () {
      final workout1 = Workout(date: DateTime.now(), sets: []);
      final workout2 =
          Workout(date: DateTime.now().add(Duration(days: 1)), sets: []);

      workoutListNotifier.addWorkout(workout1);
      workoutListNotifier.addWorkout(workout2);

      expect(workoutListNotifier.state.length, 2);

      workoutListNotifier.removeWorkout(0); // Remove first workout

      expect(workoutListNotifier.state.length, 1);
      expect(workoutListNotifier.state[0],
          workout2); // Remaining workout should be workout2
    });

    test('Edit a workout should update the correct workout', () {
      final workout1 = Workout(date: DateTime.now(), sets: []);
      final workout2 =
          Workout(date: DateTime.now().add(Duration(days: 1)), sets: []);
      final updatedWorkout =
          Workout(date: DateTime.now().add(Duration(days: 2)), sets: []);

      workoutListNotifier.addWorkout(workout1);
      workoutListNotifier.addWorkout(workout2);

      workoutListNotifier.editWorkout(
          0, updatedWorkout); // Update the first workout

      expect(workoutListNotifier.state.length, 2);
      expect(workoutListNotifier.state[0], updatedWorkout);
      expect(workoutListNotifier.state[1],
          workout2); // Second workout remains unchanged
    });

    test('Edit workout should not change state if index is out of bounds', () {
      final workout1 = Workout(date: DateTime.now(), sets: []);
      workoutListNotifier.addWorkout(workout1);

      final updatedWorkout =
          Workout(date: DateTime.now().add(Duration(days: 2)), sets: []);

      workoutListNotifier.editWorkout(
          10, updatedWorkout); // Index out of bounds

      // No changes should be made
      expect(workoutListNotifier.state.length, 1);
      expect(workoutListNotifier.state[0], workout1);
    });
  });

  group('editingWorkoutProvider Tests', () {
    test('Initial editing workout should be null', () {
      expect(container.read(editingWorkoutProvider), null);
    });

    test('Editing workout should update when set', () {
      final workout = Workout(date: DateTime.now(), sets: []);
      container.read(editingWorkoutProvider.notifier).state = workout;

      expect(container.read(editingWorkoutProvider), workout);
    });
  });

  group('editingWorkoutIndexProvider Tests', () {
    test('Initial editing workout index should be -1', () {
      expect(container.read(editingWorkoutIndexProvider), -1);
    });

    test('Editing workout index should update correctly', () {
      container.read(editingWorkoutIndexProvider.notifier).state = 0;

      expect(container.read(editingWorkoutIndexProvider), 0);
    });
  });
}
