import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'api_service.dart';
import 'app_colours.dart';
import 'task_provider.dart';
import 'textfield_input.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  // bool _status = false;

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Call the TaskProvider's addTask method
        await Provider.of<TaskProvider>(context, listen: false).addTask(
          _titleController.text,
          _bodyController.text,
          false, // Assuming the task is not completed initially
        );

        // Close the dialog after adding the task
        Navigator.of(context).pop();
      } catch (e) {
        print('Failed to create task: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create task: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              TextFieldInput(
                textEditingController: _titleController,
                hintText: 'Title of your task',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                textEditingController: _bodyController,
                hintText: 'Task description',
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
                    onPressed: _saveTask,
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppColor.appWhiteColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
