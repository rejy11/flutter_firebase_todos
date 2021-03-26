import '../../models/todo.dart';

abstract class TodosRepository {
  Future<void> addTodo(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Future<void> deleteAllTodos();
  Stream<List<Todo>> todos();
  Future<void> updateTodo(Todo todo);
}