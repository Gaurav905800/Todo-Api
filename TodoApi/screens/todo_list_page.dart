import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:text_application/TodoApi/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  Future<void> addText() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void navigateToEditPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {}
  }

  Future<void> fetchTodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addText,
        child: const Icon(Icons.add),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item["_id"] as String;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        navigateToEditPage();
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ],
                  ),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
