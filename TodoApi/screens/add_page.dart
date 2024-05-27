import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:text_application/TodoApi/custom/custom_button.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    void summitData() async {
      final title = textController.text;
      final description = descriptionController.text;
      final body = {
        "title": title,
        "description": description,
        "is_completed": false
      };

      void showSuccessMessage(String message) {
        final snackbar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }

      void showFailedMessage(String message) {
        final snackbar = SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }

      const url = "https://api.nstack.in/v1/todos";
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        textController.text = '';
        descriptionController.text = '';
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        showSuccessMessage('creation success');
      } else {
        showFailedMessage('Creation Failed');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 8,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(text: 'Save', onTap: summitData)
            ],
          ),
        ),
      ),
    );
  }
}
