import 'package:cloud_firestore/cloud_firestore.dart';

import '../../entities/todo_entity.dart';
import '../../models/todo.dart';
import 'todos_repository.dart';

class FirebaseTodosRepository implements TodosRepository {
  final todoCollection = FirebaseFirestore.instance.collection('todo');

  @override
  Future<void> addTodo(Todo todo) async {
    return await todoCollection.add(todo.toEntity().toMap());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return await todoCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.orderBy('dateCreated').snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Todo.fromEntity(
            TodoEntity.fromMap(data),
          );
          },
        )
        .toList());
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return todoCollection.doc(todo.id).update(todo.toEntity().toMap());
  }

  @override
  Future<void> deleteAllTodos() async {
    return await todoCollection.snapshots().forEach((element) { 
      for (var doc in element.docs) {
        doc.reference.delete();
      }
    });
  }
}
