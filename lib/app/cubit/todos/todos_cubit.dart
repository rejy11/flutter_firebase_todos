import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/todo.dart';
import '../../../data/repositories/todos/todos_repository.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodosRepository _todosRepository;
  StreamSubscription _todosChanges;

  TodosCubit({@required TodosRepository repo})
      : assert(repo != null),
        _todosRepository = repo,
        super(TodosLoading());

  Future<void> loadTodos() async {
    try {
      _todosChanges?.cancel();
      emit(TodosLoading());
      _todosChanges = _todosRepository.todos().listen((todos) {
        if (todos.isNotEmpty) {
          emit(TodosLoaded(todos));
        } else {
          emit(TodosEmpty());
        }
      });
    } on Exception catch (e) {
      print('error: $e');
      emit(TodosError(e.toString()));
    }
  }

  Future<void> addTodo(String task, {bool complete = false}) async {
    try {
      await _todosRepository.addTodo(Todo(
        task,
        complete: complete,
        dateCreated: DateTime.now(),
      ));
    } on Exception catch (e) {
      print('error: $e');
      emit(TodosError(e.toString()));
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _todosRepository.updateTodo(todo);
    } on Exception catch (e) {
      print('error: $e');
      emit(TodosError(e.toString()));
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await _todosRepository.deleteTodo(todo);
    } on Exception catch (e) {
      print('error: $e');
      emit(TodosError(e.toString()));
    }
  }

  Future<void> deleteAllTodos() async {
    try {
      final currentState = state;
      if (currentState is TodosLoaded) {
        _todosChanges
            ?.cancel(); //cancel this listener to avoid calling emit on states
        final allTodos = currentState.todos;
        emit(
            TodosLoading()); //emit this state so we see a loading spinner whilst we delete todos
        for (var todo in allTodos) {
          await deleteTodo(todo);
        }
      }
      await loadTodos(); //attach listener and emit appropriate states
    } on Exception catch (e) {
      print('error: $e');
      emit(TodosError(e.toString()));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('Todos Cubit: OnError');
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<TodosState> change) {
    print(
        'Todos Cubit -> Current State: ${change.currentState}, Next State: ${change.nextState}');
    super.onChange(change);
  }
}
