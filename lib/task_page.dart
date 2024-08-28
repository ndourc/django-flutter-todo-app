import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:todo_frontend/api_service.dart';
import 'package:todo_frontend/models.dart';
import 'package:todo_frontend/task_provider.dart';
import 'add_task_page.dart';
import 'app_colours.dart';
import 'edit_task_page.dart';
//import 'hover_effect.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void _editTask(Task task) {
    Navigator.pushNamed(context, EditTaskPage.routeName, arguments: task)
        .then((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _deleteTask(Task task) async {
    await showDeleteConfirmationDialog(context, task);
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, Task task) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.delete, color: AppColor.appRedColor),
                const SizedBox(width: 10),
                const Text('Delete task'),
              ],
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                const Text('Are you sure you want to delete this task?'),
                const SizedBox(height: 10),
                Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: AppColor.appRedColor),
                )
              ],
            )),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColor.appBlackColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appRedColor,
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColor.appWhiteColor),
                ),
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .deleteTask(task.id);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.appWhiteColor,
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColor.offBlackGreyColor,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColor.greenAccentColor,
                              borderRadius: BorderRadius.circular(20)),
                          height: 30,
                          width: 5,
                          padding: const EdgeInsets.all(20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Your tasks",
                          style: TextStyle(
                              color: AppColor.appWhiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                      ElevatedButton(
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenAccentColor,
                        ),
                        child: Text(' Add Task',
                            style: TextStyle(color: AppColor.appWhiteColor)),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: AppColor.appWhiteColor,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.lastUpdated),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: task.task_status,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .updateTaskStatus(task.id, value)
                                          .then((response) {
                                        // Handle the response here, e.g., show a success message
                                      }).catchError((error) {
                                        // Handle error, e.g., show an error message
                                        print(
                                            'Error updating task status: $error');
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editTask(task),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteTask(task),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
