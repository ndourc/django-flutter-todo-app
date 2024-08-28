import 'package:flutter/material.dart';
import 'api_service.dart';
import 'app_colours.dart';
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

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService().createTask(
          _titleController.text,
          _bodyController.text,
        );
        Navigator.of(context).pop();
      } catch (e) {
        print('Failed to create task: $e');
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
                textEditingController: _titleController,
                hintText: 'Title of your task',
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
