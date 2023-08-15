import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: TodoListApp(),
  ));
}

class TodoList {
  String description;
  bool isFinished;

  TodoList({required this.description, this.isFinished = false});
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final TextEditingController _todoController = TextEditingController();
  final List<TodoList> _todos = [];

  void _addTodo() {
    setState(() {
      _todos.add(TodoList(
        description: _todoController.text,
        isFinished: false,
      ));
      _todoController.clear();
    });
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isFinished = !_todos[index].isFinished;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _renameTodo(int index) async {
    TextEditingController renameController =
        TextEditingController(text: _todos[index].description);

    String updatedDescription = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Todo'),
          content: TextField(
            controller: renameController,
            onChanged: (text) {},
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(renameController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    setState(() {
      _todos[index].description = updatedDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _todos[index].description,
                    style: _todos[index].isFinished
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough)
                        : const TextStyle(),
                  ),
                  onTap: () => _toggleTodoStatus(index),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _renameTodo(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTodo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 38),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a todo...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
