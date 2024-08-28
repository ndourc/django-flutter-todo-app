class Urls {
  static const String baseUrl = "http://127.0.0.1:8000";

  static String createTask() => "$baseUrl/tasks/add-task/";
  static String getTasks() => "$baseUrl/tasks/";
  static String getSingleTask(String id) => "$baseUrl/tasks/$id/";
  static String updateTask(String id) => "$baseUrl/tasks/$id/update/";
  static String deleteTask(String id) => "$baseUrl/tasks/$id/delete/";
}
