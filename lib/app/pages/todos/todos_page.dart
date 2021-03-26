import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../data/test_data.dart';
import '../../cubit/authentication/authentication_cubit.dart';
import '../../cubit/todos/todos_cubit.dart';
import 'add_todo_page.dart';

class TodosPage extends StatefulWidget {
  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TodosCubit todosCubit;

  @override
  void initState() {
    todosCubit = BlocProvider.of<TodosCubit>(context);
    todosCubit.loadTodos();
    super.initState();
  }

  Future<void> _insertTestData() async {
    for (var task in tasks) {
      await todosCubit.addTodo(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text('Remove All'), value: 1),
                PopupMenuItem(child: Text('Remove All Completed'), value: 4),
                PopupMenuItem(child: Text('Insert Test Data'), value: 2),
                PopupMenuItem(child: Text('Logout'), value: 3),                
              ];
            },
            onSelected: (value) async {
              if (value == 1) {
                //remove all
                await todosCubit.deleteAllTodos();
              } else if (value == 2) {
                //insert test data
                await _insertTestData();
              } else if (value == 3) {
                //logout
                BlocProvider.of<AuthenticationCubit>(context).signOut();
              } else if (value == 4) {
                
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<TodosCubit, TodosState>(
        listener: (context, state) {
          if (state is TodosError) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error loading Todos'),
                  content: Text(state.error),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is TodosEmpty) {
            return Center(
              child: Text(
                'You have no todos!',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (state is TodosLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: CheckboxListTile(
                          title: Text(todo.task),
                          value: todo.complete,
                          onChanged: (value) {
                            BlocProvider.of<TodosCubit>(context).updateTodo(
                              todo.copyWith(
                                complete: value,
                              ),
                            );
                          },
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Delete',
                            icon: Icons.delete_rounded,
                            foregroundColor: Colors.red[400],
                            color: Theme.of(context).scaffoldBackgroundColor,
                            onTap: () async {
                              final _todo = todo;
                              await todosCubit.deleteTodo(todo);
                              ScaffoldMessenger.of(_scaffoldKey.currentContext)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text('${_todo.task} removed'),
                                  action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () async {
                                        await todosCubit.addTodo(_todo.task,
                                            complete: _todo.complete);
                                      }),
                                ),
                              );
                            },
                          ),
                          IconSlideAction(
                            caption: 'Edit',
                            icon: Icons.edit_rounded,
                            foregroundColor: Theme.of(context).accentColor,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddTodoPage(
                                    todosCubit: this.todosCubit,
                                    todo: todo,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodoPage(todosCubit: this.todosCubit),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
