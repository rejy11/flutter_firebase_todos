part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userId;

  Authenticated(this.userId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Authenticated && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

class AuthenticationError extends AuthenticationState {
  final String error;

  AuthenticationError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AuthenticationError &&
      other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
