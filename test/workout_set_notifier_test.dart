import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:fitnessapp/src/providers/workout_set_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WorkoutSetNotifier notifier;
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(workoutSetProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('Initial state should be empty', () {
    expect(notifier.state, []);
  });

  test('Add a set should add a WorkoutSet to the list', () {
    final newSet =
        WorkoutSet(exercise: 'Bench press', weight: 100, repetitions: 10);
    notifier.addSet(newSet);

    expect(notifier.state.length, 1);
    expect(notifier.state[0], newSet);
  });

  test('Remove a set should remove the set at the correct index', () {
    final set1 = WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 8);
    final set2 = WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5);

    notifier.addSet(set1);
    notifier.addSet(set2);

    expect(notifier.state.length, 2);
    notifier.removeSet(0); // Remove the first set

    expect(notifier.state.length, 1);
    expect(notifier.state[0], set2); // Remaining set should be set2
  });

  test('Clear sets should remove all sets', () {
    final set1 = WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 8);
    final set2 = WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5);

    notifier.addSet(set1);
    notifier.addSet(set2);

    expect(notifier.state.length, 2);

    notifier.clearSets();

    expect(notifier.state.isEmpty, true);
  });

  test('Update sets should replace all sets with new sets', () {
    final set1 = WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 8);
    final set2 = WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5);
    final newSets = [
      WorkoutSet(exercise: 'Bench press', weight: 100, repetitions: 10)
    ];

    notifier.addSet(set1);
    notifier.addSet(set2);

    expect(notifier.state.length, 2);

    notifier.updateSets(newSets);

    expect(notifier.state.length, 1);
    expect(notifier.state[0], newSets[0]);
  });

  test('Update set by index should modify the correct set', () {
    final set1 = WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 8);
    final set2 = WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5);

    notifier.addSet(set1);
    notifier.addSet(set2);

    final updatedSet =
        WorkoutSet(exercise: 'Bench press', weight: 90, repetitions: 12);
    notifier.updateSet(0, updatedSet);

    expect(notifier.state[0], updatedSet);
    expect(notifier.state[1], set2); // set2 should remain unchanged
  });

  test('Update set should not change the list if index is out of bounds', () {
    final set1 = WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 8);

    notifier.addSet(set1);

    final updatedSet =
        WorkoutSet(exercise: 'Bench press', weight: 90, repetitions: 12);
    notifier.updateSet(1, updatedSet); // Index 1 is out of bounds

    expect(notifier.state.length, 1);
    expect(notifier.state[0], set1); // No change in state
  });
}
