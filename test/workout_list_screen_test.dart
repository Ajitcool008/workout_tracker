import 'package:fitnessapp/src/models/workout_model.dart';
import 'package:fitnessapp/src/providers/workout_provider.dart';
import 'package:fitnessapp/src/views/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Displays "No Workouts" when workout list is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );

    expect(find.text('No Workouts'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Displays workouts in the list when workouts exist',
      (WidgetTester tester) async {
    final testWorkout = Workout(date: DateTime.now(), sets: []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListProvider.overrideWith(
              (ref) => WorkoutListNotifier()..addWorkout(testWorkout)),
        ],
        child: const MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
    expect(
        find.text('Workout on ${testWorkout.date.toLocal().toIso8601String()}'),
        findsOneWidget);
  });

  testWidgets('Navigates to workout screen when tapping on a workout',
      (WidgetTester tester) async {
    final testWorkout = Workout(date: DateTime.now(), sets: []);
    late String pushedRoute;

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const WorkoutListScreen()),
        GoRoute(
            path: '/workout',
            builder: (_, __) {
              pushedRoute = '/workout';
              return const Scaffold();
            }),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListProvider.overrideWith(
              (ref) => WorkoutListNotifier()..addWorkout(testWorkout)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(pushedRoute, equals('/workout'));
  });
  testWidgets('Removes a workout when delete icon is pressed',
      (WidgetTester tester) async {
    final testWorkout = Workout(date: DateTime.now(), sets: []);

    // Use a single ProviderScope with the overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListProvider.overrideWith(
              (ref) => WorkoutListNotifier()..addWorkout(testWorkout)),
        ],
        child: const MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );

    // Verify that the workout is present
    expect(find.byType(ListTile), findsOneWidget);
    expect(
        find.text('Workout on ${testWorkout.date.toLocal().toIso8601String()}'),
        findsOneWidget);

    // Simulate deleting the workout
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify that the workout has been removed
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('No Workouts'), findsOneWidget);
  });

  testWidgets(
      'Navigates to add workout screen when floating action button is pressed',
      (WidgetTester tester) async {
    late String pushedRoute;

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const WorkoutListScreen()),
        GoRoute(
            path: '/workout',
            builder: (_, __) {
              pushedRoute = '/workout';
              return const Scaffold();
            }),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(pushedRoute, equals('/workout'));
  });
}
