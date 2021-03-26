import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final String task;
  final bool complete;
  final Timestamp dateCreated;

  TodoEntity(this.id, this.task, this.complete, this.dateCreated);

  @override
  List<Object> get props => [id, task, complete, dateCreated];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'complete': complete,
      'dateCreated' : dateCreated,
    };
  }

  factory TodoEntity.fromMap(Map<String, dynamic> map) {
    return TodoEntity(
      map['id'],
      map['task'],
      map['complete'],
      map['dateCreated'],      
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoEntity.fromJson(String source) =>
      TodoEntity.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}