import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String task;
  final bool complete;
  final Timestamp dateCreated;

  TodoEntity(
    this.task,
    this.complete,
    this.dateCreated,
  );

  @override
  List<Object> get props => [
        task,
        complete,
        dateCreated,
      ];

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'complete': complete,
      'dateCreated' : dateCreated,
    };
  }

  factory TodoEntity.fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      map['task'],
      map['complete'],
      map['dateCreated'],
    );
  }

  @override
  bool get stringify => true;
}
