import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../entities/todo_entity.dart';

@immutable
class Todo {
  final String id;
  final String task;
  final bool complete;
  final DateTime dateCreated;

  Todo(
    this.task, {
    this.complete = false,
    this.id,
    this.dateCreated,
  });

  TodoEntity toEntity() {
    return TodoEntity(
      this.task,
      this.complete,
      Timestamp.fromDate(this.dateCreated),
    );
  }

  static Todo fromEntity(TodoEntity entity, String id) {
    return Todo(
      entity.task,
      complete: entity.complete ?? false,
      id: id,
      dateCreated: entity.dateCreated.toDate(),
    );
  }

  Todo copyWith({
    String id,
    String task,
    bool complete,
    DateTime dateCreated,
  }) {
    return Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.id == id &&
        other.task == task &&
        other.complete == complete &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      task.hashCode ^
      complete.hashCode ^
      dateCreated.hashCode;
  }

  @override
  String toString() {
    return 'Todo(id: $id, task: $task, complete: $complete, dateCreated: $dateCreated)';
  }
}
