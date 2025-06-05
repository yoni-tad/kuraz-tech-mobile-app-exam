import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/Todo.dart';
import 'package:todo/provider/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selected = 'All';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _todoController = TextEditingController();
    final todos = Provider.of<TodoProvider>(context).todos;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todo List',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selected,
                            borderRadius: BorderRadius.circular(12.r),
                            items: [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: 'Completed',
                                child: Text('Completed'),
                              ),
                              DropdownMenuItem(
                                value: 'Pending',
                                child: Text('Pending'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selected = value.toString();
                              });
                              if (value == 'All') {
                                Provider.of<TodoProvider>(
                                  context,
                                  listen: false,
                                ).getTodos();
                              } else if (value == 'Completed') {
                                Provider.of<TodoProvider>(
                                  context,
                                  listen: false,
                                ).filter(true);
                              } else if (value == 'Pending') {
                                Provider.of<TodoProvider>(
                                  context,
                                  listen: false,
                                ).filter(false);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              todos.isEmpty
                  ? Text(
                    "No todo list found!",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  : Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.h,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 15.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<TodoProvider>(
                                            context,
                                            listen: false,
                                          ).toggleTodo(todos[index].id);
                                        },
                                        child: Icon(
                                          todos[index].isCompleted
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color:
                                              todos[index].isCompleted
                                                  ? Colors.green
                                                  : Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(todos[index].title),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<TodoProvider>(
                                        context,
                                        listen: false,
                                      ).deleteTodos(todos[index].id);
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Enter todo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_todoController.text.trim().isNotEmpty) {
                        Provider.of<TodoProvider>(
                          context,
                          listen: false,
                        ).addTodos(
                          Todo(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: _todoController.text.trim(),
                            isCompleted: false,
                          ),
                        );
                        _todoController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Title must not be empty')),
                        );
                      }
                    },
                    child: Icon(Icons.add, color: Colors.white, size: 14.h),
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
