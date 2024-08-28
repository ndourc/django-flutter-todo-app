import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_frontend/api_service.dart';
import 'add_task_page.dart';
import 'app_colours.dart';
import 'edit_task_page.dart';
import 'hover_effect.dart';
import 'models.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = ApiService().getTasks();
  }

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    ).then((_) {
      setState(() {
        futureTasks = ApiService().getTasks();
      });
    });
  }

  void _editTask(Task task) {
    Navigator.pushNamed(context, EditTaskPage.routeName, arguments: task)
        .then((_) {
      setState(() {
        futureTasks = ApiService().getTasks();
      });
    });
  }

// B U L K  O F  D E L E T E  M E T H O D S
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
                  _confirmDelete(task);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _confirmDelete(Task task) async {
    try {
      await ApiService().deleteTask(task.id);
      setState(() {
        futureTasks = ApiService().getTasks();
      });
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
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
              FutureBuilder<List<Task>>(
                  future: futureTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: AppColor.appWhiteColor,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: AppColor.appWhiteColor),
                      );
                    } else if (snapshot.hasData) {
                      return Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppColor.dashboardGreyColor,
                                    width: 0.5),
                              ),
                            ),
                            children: [
                              tableHeader("Task ID"),
                              tableHeader("Title"),
                              tableHeader("Last Updated")
                            ],
                          ),
                          ...snapshot.data!.map((task) {
                            return TableRow(children: [
                              OnHoverButton(
                                  onEdit: () => _editTask(task),
                                  onDelete: () => _deleteTask(task),
                                  child: tableCell(task.id)),
                              OnHoverButton(
                                  onEdit: () => _editTask(task),
                                  onDelete: () => _deleteTask(task),
                                  child: tableCell(task.title)),
                              OnHoverButton(
                                  onEdit: () => _editTask(task),
                                  onDelete: () => _deleteTask(task),
                                  child: tableCell(task.lastUpdated)),
                            ]);
                          })
                        ],
                      );
                    } else {
                      return Text(
                        'No data available',
                        style: TextStyle(color: AppColor.appWhiteColor),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: AppColor.appWhiteColor),
      ),
    );
  }

  Widget tableCell(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(color: AppColor.appWhiteColor),
      ),
    );
  }
}
