import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:fitnessapp/src/providers/workout_provider.dart';
import 'package:fitnessapp/src/providers/workout_set_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  String selectedExercise = 'Select Exercise';
  int? editingSetIndex; // Tracks if we are editing a set (null if not editing)

  @override
  void initState() {
    super.initState();

    // Load existing workout sets if editing
    final workout = ref.read(editingWorkoutProvider);
    if (workout != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensures the widget is built before updating the state
        ref.read(workoutSetProvider.notifier).updateSets(workout.sets);
      });
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  void addOrUpdateSet() {
    final weight = int.tryParse(weightController.text);
    final reps = int.tryParse(repsController.text);

    if (weight != null &&
        reps != null &&
        selectedExercise != 'Select Exercise') {
      final newSet = WorkoutSet(
          exercise: selectedExercise, weight: weight, repetitions: reps);

      if (editingSetIndex == null) {
        // If not editing, add new set
        ref.read(workoutSetProvider.notifier).addSet(newSet);
      } else {
        // If editing, update the existing set
        ref
            .read(workoutSetProvider.notifier)
            .updateSet(editingSetIndex!, newSet);
        setState(() {
          editingSetIndex = null; // Reset the editing mode
        });
      }

      // Clear input fields after adding or editing the set
      weightController.clear();
      repsController.clear();
      setState(() {
        selectedExercise = 'Select Exercise'; // Reset dropdown
      });
    }
  }

  void saveWorkout() {
    final workoutSets = ref.read(workoutSetProvider);
    final newWorkout = Workout(date: DateTime.now(), sets: workoutSets);

    if (ref.read(editingWorkoutProvider.notifier).state != null) {
      // Edit an existing workout
      ref.read(workoutListProvider.notifier).editWorkout(
          ref.read(editingWorkoutIndexProvider.notifier).state, newWorkout);
    } else {
      // Add a new workout
      ref.read(workoutListProvider.notifier).addWorkout(newWorkout);
    }
    ref.read(workoutSetProvider.notifier).clearSets();
    // Navigate back to the workout list screen
    context.go('/');
  }

  void deleteWorkout() {
    if (ref.read(editingWorkoutProvider.notifier).state != null) {
      // Delete the workout
      ref
          .read(workoutListProvider.notifier)
          .removeWorkout(ref.read(editingWorkoutIndexProvider.notifier).state);
      ref.read(workoutSetProvider.notifier).clearSets();
      // Navigate back to the workout list screen
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(workoutSetProvider.notifier).clearSets();
            context.go('/');
          },
        ),
        title: Text(ref.read(editingWorkoutProvider.notifier).state != null
            ? 'Edit Workout'
            : 'Add Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedExercise,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedExercise = value;
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                    value: 'Select Exercise', child: Text('Select Exercise')),
                DropdownMenuItem(
                    value: 'Bench press', child: Text('Bench press')),
                DropdownMenuItem(value: 'Squat', child: Text('Squat')),
                DropdownMenuItem(value: 'Deadlift', child: Text('Deadlift')),
                DropdownMenuItem(
                    value: 'Shoulder press', child: Text('Shoulder press')),
                DropdownMenuItem(
                    value: 'Barbell row', child: Text('Barbell row')),
              ],
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Repetitions'),
            ),
            ElevatedButton(
              onPressed: addOrUpdateSet,
              child: Text(editingSetIndex == null ? 'Add Set' : 'Edit Set'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: ref.watch(workoutSetProvider).length,
                itemBuilder: (context, index) {
                  final set = ref.watch(workoutSetProvider)[index];
                  return ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          // Populate the fields with the selected set's values
                          weightController.text = set.weight.toString();
                          repsController.text = set.repetitions.toString();
                          selectedExercise = set.exercise;

                          // Set the index to indicate we're editing this set
                          editingSetIndex = index;
                        });
                      },
                    ),
                    title: Text(
                        '${set.exercise} - ${set.weight}kg, ${set.repetitions} reps'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(workoutSetProvider.notifier).removeSet(index);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: saveWorkout,
                  child: const Text('Save Workout'),
                ),
                if (ref.read(editingWorkoutProvider.notifier).state !=
                    null) // Show delete button only if editing
                  ElevatedButton(
                    onPressed: deleteWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Workout'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
