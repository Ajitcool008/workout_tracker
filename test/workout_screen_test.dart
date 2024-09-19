import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:fitnessapp/src/providers/workout_set_provider.dart';
import 'package:fitnessapp/src/views/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutScreen', () {
    testWidgets('adds a new set correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WorkoutScreen(),
          ),
        ),
      );

      // Fill in exercise and set details
      await tester.tap(find.text('Select Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench press').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '100'); // Weight
      await tester.enterText(find.byType(TextField).last, '8'); // Repetitions

      // Tap the "Add Set" button
      await tester.tap(find.text('Add Set'));
      await tester.pumpAndSettle();

      // Verify that the set is added
      expect(find.text('Bench press - 100kg, 8 reps'), findsOneWidget);
    });

    testWidgets('edits an existing set correctly', (WidgetTester tester) async {
      final testSet =
          WorkoutSet(exercise: 'Squat', weight: 80, repetitions: 10);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutSetProvider.overrideWith(
              (ref) => WorkoutSetNotifier()..addSet(testSet),
            ),
          ],
          child: const MaterialApp(
            home: WorkoutScreen(),
          ),
        ),
      );

      // Verify initial set is displayed
      expect(find.text('Squat - 80kg, 10 reps'), findsOneWidget);

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Modify the weight and repetitions
      await tester.enterText(find.byType(TextField).first, '90'); // Weight
      await tester.enterText(find.byType(TextField).last, '12'); // Repetitions

      // Tap the "Edit Set" button
      await tester.tap(find.text('Edit Set'));
      await tester.pumpAndSettle();

      // Verify that the set is updated
      expect(find.text('Squat - 90kg, 12 reps'), findsOneWidget);
    });

    testWidgets('removes a set correctly', (WidgetTester tester) async {
      final testSet =
          WorkoutSet(exercise: 'Deadlift', weight: 120, repetitions: 5);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutSetProvider.overrideWith(
              (ref) => WorkoutSetNotifier()..addSet(testSet),
            ),
          ],
          child: const MaterialApp(
            home: WorkoutScreen(),
          ),
        ),
      );

      // Verify initial set is displayed
      expect(find.text('Deadlift - 120kg, 5 reps'), findsOneWidget);

      // Tap the delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify the set is removed
      expect(find.text('Deadlift - 120kg, 5 reps'), findsNothing);
    });
  });
}
