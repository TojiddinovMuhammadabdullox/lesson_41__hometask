import 'package:flutter/material.dart';
import '../model/todo.dart';

class TodoController with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
    notifyListeners();
  }

  void editTodo(String id, String newTitle) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.title = newTitle;
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }

  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get incompleteCount => _todos.where((todo) => !todo.isCompleted).length;
}
