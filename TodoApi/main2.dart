import 'package:flutter/material.dart';
import 'package:text_application/TodoApi/screens/todo_list_page.dart';

void main(List<String> args) {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const TodoListPage(),
    );
  }
}
