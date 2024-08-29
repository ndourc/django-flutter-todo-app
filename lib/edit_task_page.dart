import 'package:flutter/material.dart';

import 'api_service.dart';
import 'app_colours.dart';
import 'models.dart';
import 'textfield_input.dart';

class EditTaskPage extends StatefulWidget {
  static const routeName = '/edit-task';

  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController titleController;
  late TextEditingController bodyController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    titleController.text = widget.task.title;
    bodyController.text = widget.task.body;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    Task updatedTask = widget.task.copyWith(
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
