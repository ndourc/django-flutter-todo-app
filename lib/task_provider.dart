import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await ApiService().getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String body) async {
    _isLoading = true;
    notifyListeners();
    _tasks.add(await ApiService().createTask(title, body));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await ApiService().deleteTask(id);
    await fetchTasks();
  }

  Future<void> updateTaskStatus(String id, String status) async {
    await ApiService().updateTaskStatus(id, status as bool);
    await fetchTasks();
  }
}
