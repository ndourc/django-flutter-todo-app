import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_frontend/task_page.dart';
import 'edit_task_page.dart';
import 'task_provider.dart';
import 'models.dart'; // Make sure to import the Task model

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TaskProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To-Do App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskPage(),
      onGenerateRoute: (settings) {
        if (settings.name == EditTaskPage.routeName) {
          final task = settings.arguments as Task;
          return MaterialPageRoute(
            builder: (context) {
              return EditTaskPage(task: task);
            },
          );
        }
        return null;
      },
    );
  }
}
