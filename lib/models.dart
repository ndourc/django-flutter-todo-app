import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String body;
  bool task_status; // Change here
  final String lastUpdated;

  Task({
    required this.id,
    required this.title,
    required this.body,
    required this.task_status, // Change here
    required this.lastUpdated,
  });

  Task copyWith({
    String? id,
    String? title,
    String? body,
    bool? task_status, // Change here
    String? lastUpdated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      task_status: task_status ?? this.task_status, // Change here
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'task_status': task_status, // Change here
      'lastUpdated': lastUpdated,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      task_status: map['task_status'] == true ||
          map['task_status'] == 'true', // Change here
      lastUpdated: map['lastUpdated'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Task(id: $id, title: $title, body: $body, task_status: $task_status, lastUpdated: $lastUpdated)'; // Change here
  }
}
