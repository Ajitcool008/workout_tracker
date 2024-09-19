class WorkoutSet {
  final String exercise;
  final int weight;
  final int repetitions;

  WorkoutSet({
    required this.exercise,
    required this.weight,
    required this.repetitions,
  });
}

class Workout {
  final DateTime date;
  final List<WorkoutSet> sets;

  Workout({required this.date, required this.sets});
}
