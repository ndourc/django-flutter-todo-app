import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String body;
  final bool status;
  final String lastUpdated;

  Task({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.lastUpdated,
  });

  Task copyWith({
    String? id,
    String? title,
    String? body,
    bool? status,
    String? lastUpdated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'status': status,
      'lastUpdated': lastUpdated,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      status: map['status'] == true || map['status'] == 'true',
      lastUpdated: map['lastUpdated'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Task(id: $id, title: $title, body: $body, status: $status, lastUpdated: $lastUpdated)';
  }
}
