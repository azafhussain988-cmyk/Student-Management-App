import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../services/api_simulation.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  final StorageService _storage = StorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Step 1: Try to load saved tasks from local storage
    final savedTasks = await _storage.loadTasks();

    if (!mounted) return;

    if (savedTasks.isNotEmpty) {
      setState(() {
        _tasks = savedTasks;
        _isLoading = false;
      });
    } else {
      // Step 2: If no saved tasks, fetch from API simulation
      final dummyTasks = await fetchDummyTasks();

      if (!mounted) return;

      setState(() {
        _tasks = dummyTasks;
        _isLoading = false;
      });
      await _storage.saveTasks(_tasks);
    }
  }

  Future<void> _addTask(String title) async {
    setState(() {
      _tasks.add(Task(title: title));
    });
    await _storage.saveTasks(_tasks);
  }

  Future<void> _toggleTask(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    await _storage.saveTasks(_tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Student Task Manager'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No tasks yet. Tap + to add one!'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) => TaskItem(
                    task: _tasks[index],
                    onToggle: () => _toggleTask(index),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTitle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (newTitle != null && newTitle.toString().isNotEmpty) {
            await _addTask(newTitle.toString());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
