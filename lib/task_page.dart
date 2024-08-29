import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'task_provider.dart';
import 'edit_task_page.dart';
import 'add_task_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _editTask(Task task) {
    print('Navigating to edit task: ${task.title}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(task: task),
      ),
    ).then((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    ).then((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.body),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.task_status,
                          onChanged: (bool? value) {
                            if (value != null) {
                              Provider.of<TaskProvider>(context, listen: false)
                                  .updateTaskStatus(task.id, value);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<TaskProvider>(context, listen: false)
                                .deleteTask(task.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
