import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/Todo.dart';

class TodoRepo {
  static const String _key = 'kuraz';
  Future prefs = SharedPreferences.getInstance();

  Future getTodos() async {
    final SharedPreferences pref = await prefs;
    final todos = pref.getString(_key);

    if (todos != null) {
      return json.decode(todos).map((todo) => Todo.fromJson(todo)).toList();
    } else {
      return [];
    }
  }

  Future saveTodo(List todos) async {
    final SharedPreferences pref = await prefs;
    final todo = json.encode(todos);
    await pref.setString(_key, todo);
  }
}
