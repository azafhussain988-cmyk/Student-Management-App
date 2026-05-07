import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const TaskItem({super.key, required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Icon
          Icon(
            task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.grey,
            size: 24,
          ),
          
          const SizedBox(width: 12),
          
          // Task Title
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
            ),
          ),
          
          // Toggle Button
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                task.isCompleted ? Icons.undo : Icons.done,
                color: task.isCompleted ? Colors.orange : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}