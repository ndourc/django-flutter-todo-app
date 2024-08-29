import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'urls.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // T A S K  C R U D  O P E R A T I O N S
  Future<Task> createTask(String title, String body, bool task_status) async {
    final response = await client.post(
      Uri.parse(Urls.createTask()),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'title': title,
        'body': body,
        'task_status': task_status,
      }),
    );

    if (response.statusCode == 201) {
      return Task.fromMap(json.decode(response.body));
    } else {
      print('Failed to create task: ${response.body}');
      throw Exception('Failed to create task');
    }
  }

  Future<List<Task>> getTasks() async {
    final response = await client.get(Uri.parse(Urls.getTasks()));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Task> tasks =
          jsonList.map((json) => Task.fromMap(json)).toList();
      return tasks;
    } else {
      print('Failed to fetch tasks: ${response.body}');
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<Task> getSingleTask(String id) async {
    final response = await client.get(Uri.parse(Urls.getSingleTask(id)));
    if (response.statusCode == 200) {
      return Task.fromMap(json.decode(response.body));
    } else {
      print('Failed to fetch task: ${response.body}');
      throw Exception('Failed to fetch task');
    }
  }

  Future<Task> updateTask(String id, String title, String body) async {
    final response = await client.put(
      Uri.parse(Urls.updateTask(id)),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'title': title,
        'body': body,
      }),
    );
    if (response.statusCode == 200) {
      return Task.fromMap(json.decode(response.body));
    } else {
      print('Failed to update task: ${response.body}');
      throw Exception('Failed to update task');
    }
  }

  Future<Task> updateTaskStatus(String id, bool task_status) async {
    final response = await client.put(
      Uri.parse(Urls.updateTask(id)),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'task_status': task_status,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromMap(json.decode(response.body));
    } else {
      print('Failed to update task status: ${response.body}');
      throw Exception('Failed to update task status');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await client.delete(Uri.parse(Urls.deleteTask(id)));
    if (response.statusCode == 204) {
      print('Task deleted successfully');
    } else {
      //print('Failed to delete task: ${response.body}');
      throw Exception('Failed to delete task');
    }
  }
}
