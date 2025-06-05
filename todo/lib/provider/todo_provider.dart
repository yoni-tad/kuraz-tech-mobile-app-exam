import 'package:flutter/material.dart';
import 'package:todo/models/Todo.dart';
import 'package:todo/repo/todo_repo.dart';

class TodoProvider with ChangeNotifier {
  List _todos = [];
  List _allTodos = [];
  final TodoRepo repository = TodoRepo();

  List get todos => _todos;
  List get allTodos => _allTodos;

  Future addTodos(Todo todo) async {
    _todos.add(todo);
    await repository.saveTodo(_todos);
    notifyListeners();
  }

  Future getTodos() async {
    final todos = await repository.getTodos();
    _todos = todos;
    _allTodos = todos;
    notifyListeners();
  }

  Future toggleTodo(int id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index >= 0) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      await repository.saveTodo(_todos);
      notifyListeners();
    }
  }

  Future deleteTodos(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await repository.saveTodo(_todos);
    notifyListeners();
  }

  Future filter(bool status) async {
    if (status) {
      _todos = _allTodos.where((allTodos) => allTodos.isCompleted == true).toList();
      notifyListeners();
    } else {
      _todos = _allTodos.where((allTodos) => allTodos.isCompleted == false).toList();
      notifyListeners();
    }
  }
}
