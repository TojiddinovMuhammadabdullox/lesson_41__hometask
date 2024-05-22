import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/todo_controller.dart';
import 'model/todo.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TodoController(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TO-DO App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'New Todo'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    todoController.addTodo(_textController.text);
                    _textController.clear();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoController.todos.length,
              itemBuilder: (context, index) {
                final todo = todoController.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      todoController.toggleTodoStatus(todo.id);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTodoDialog(context, todo);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          todoController.deleteTodo(todo.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Completed: ${todoController.completedCount}'),
                Text('Incomplete: ${todoController.incompleteCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editTodoDialog(BuildContext context, Todo todo) {
    final _editTextController = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: _editTextController,
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Provider.of<TodoController>(context, listen: false)
                    .editTodo(todo.id, _editTextController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
