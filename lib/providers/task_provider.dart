import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Map> taskBox = Hive.box<Map>('tasks');

  List<Task> getTasks() {
    return taskBox.values
        .map((task) => Task.fromMap(Map<String, dynamic>.from(task)))
        .toList();
  }

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(seconds: 2));
    await taskBox.put(task.id, task.toMap());
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(seconds: 2));
    await taskBox.put(task.id, task.toMap());
    notifyListeners();
  }

  void deleteTask(String id) {
    taskBox.delete(id);
    notifyListeners();
  }
}