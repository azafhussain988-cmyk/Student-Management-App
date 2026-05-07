import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final tasksJson = prefs.getStringList(_tasksKey);
    if (tasksJson == null) return [];
    return tasksJson
        .map((item) => Task.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .where((task) => task.title.isNotEmpty)
        .toList();
  }
}
