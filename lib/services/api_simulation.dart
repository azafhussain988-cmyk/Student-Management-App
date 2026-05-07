import '../models/task.dart';

Future<List<Task>> fetchDummyTasks() async {
  // Simulate network delay of 2 seconds
  await Future.delayed(Duration(seconds: 2));
  
  return [
    Task(title: 'Read Flutter documentation', isCompleted: false),
    Task(title: 'Submit Mobile App Dev Lab', isCompleted: true),
    Task(title: 'Prepare for quiz', isCompleted: false),
    Task(title: 'Review SharedPreferences', isCompleted: false),
  ];
}