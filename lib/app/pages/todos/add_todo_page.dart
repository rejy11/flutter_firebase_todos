import 'package:flutter/material.dart';
import 'package:todos_app/app/cubit/todos/todos_cubit.dart';
import 'package:todos_app/data/models/todo.dart';

class AddTodoPage extends StatefulWidget {
  final TodosCubit todosCubit;
  final Todo todo;
  final bool editMode;

  const AddTodoPage({
    Key key,
    @required this.todosCubit,
    this.todo,
  })  : editMode = todo != null,
        super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _controller;
  FocusNode focusNode;

  @override
  void initState() {
    _controller =
        TextEditingController(text: widget.editMode ? widget.todo.task : null);
    _controller.addListener(() {
      setState(() {});
    });
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    super.initState();
  }

  void _createNewTodo() {
    if (widget.editMode) {
      widget.todosCubit
          .updateTodo(widget.todo.copyWith(task: _controller.text));
    } else {
      widget.todosCubit.addTodo(_controller.text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.editMode ? 'Edit Todo' : 'New Todo'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextField(
                autofocus: true,
                focusNode: focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0, color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _controller.text.isNotEmpty ? _createNewTodo : null,
                      child: Text(widget.editMode ? 'Save' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(20, 40),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
