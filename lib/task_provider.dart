import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';
import 'package:http/http.dart' as http;

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await ApiService().getTasks();
    } catch (e) {
      print('Failed to fetch tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title, String body, bool task_status) async {
    try {
      Task newTask = await ApiService().createTask(title, body, task_status);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      print('Failed to add task: $e');
    }
  }

  Future<void> updateTaskStatus(String id, bool task_status) async {
    try {
      final apiService = ApiService(client: http.Client());
      await apiService.updateTaskStatus(id, task_status);

      // Update the local task status in the list
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex >= 0) {
        _tasks[taskIndex].task_status = task_status; // Update the task_status
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await ApiService().deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }
}
