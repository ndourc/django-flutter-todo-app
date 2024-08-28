import 'package:flutter/material.dart';

import 'api_service.dart';
import 'app_colours.dart';
import 'models.dart';
import 'textfield_input.dart';

class EditTaskPage extends StatefulWidget {
  static const routeName = '/edit-task';

  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late Task task;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    task = ModalRoute.of(context)!.settings.arguments as Task;
    titleController = TextEditingController(text: task.title);
    bodyController = TextEditingController(text: task.body);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    Task updatedTask = task.copyWith(
      title: titleController.text,
      body: bodyController.text,
    );

    try {
      await ApiService().updateTask(
        updatedTask.id,
        updatedTask.title,
        updatedTask.body,
      );

      print("Task updated successfully: $updatedTask");
      Navigator.pop(context);
    } catch (e) {
      print("Failed to update task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldInput(
                    textEditingController: titleController,
                    hintText: 'Title...',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFieldInput(
                    textEditingController: bodyController,
                    hintText: 'Task description...',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColor.appBlackColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 9),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenAccentColor,
                        ),
                        onPressed: _saveForm,
                        child: Text(
                          'Save',
                          style: TextStyle(color: AppColor.appWhiteColor),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
