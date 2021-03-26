part of 'todos_cubit.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo> todos;

  TodosLoaded(this.todos);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodosLoaded && listEquals(other.todos, todos);
  }

  @override
  int get hashCode => todos.hashCode;
}

class TodosEmpty extends TodosState {}

class TodosError extends TodosState {
  final String error;

  TodosError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodosError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
