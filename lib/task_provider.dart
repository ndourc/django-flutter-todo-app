import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';
import 'package:http/http.dart' as http;

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Task> get tasks => _tasks;

  // Fetch tasks from the API
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners before fetching
    try {
      final List<Task> fetchedTasks = await ApiService().getTasks();
      _tasks = fetchedTasks;
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after fetching
    }
  }

  // Add a new task
// Add a new task
  Future<void> addTask(String title, String body, bool task_status) async {
    try {
      // Create the task using the API
      Task newTask = await ApiService().createTask(title, body, task_status);

      // Optionally, add the new task to the local list
      _tasks.add(newTask);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Update a task
  Future<void> updateTask(String id, String title, String body) async {
    try {
      await ApiService().updateTask(id, title, body);
      await fetchTasks(); // Refresh the task list
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await ApiService().deleteTask(id);
      await fetchTasks(); // Refresh the task list
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Update task status (completion status)
  Future<void> updateTaskStatus(String id, bool task_status) async {
    try {
      // Create an instance of ApiService with an http.Client
      final apiService = ApiService(client: http.Client());

      // Call the API to update the task status
      await apiService.updateTaskStatus(id, task_status);

      // Update the local task status in the list
      final taskIndex = _tasks.indexWhere((task) => task.id == id);
      if (taskIndex >= 0) {
        _tasks[taskIndex].task_status = task_status;
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update task status: $e');
    }
  }
}
