import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/authentication/auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepository _authRepository;
  StreamSubscription _authChanges;

  AuthenticationCubit({@required AuthRepository repo})
      : assert(repo != null),
        _authRepository = repo,
        super(Unauthenticated());

  Future<void> signIn() async {
    try {
      emit(AuthenticationLoading());
      await _authRepository.signIn();
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationError(e.message));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void authChanges() {
    _authChanges?.cancel();
    _authChanges = _authRepository.authChanges().listen((user) {
      if (user is User && user != null) {
        emit(Authenticated(user.uid));
      } else {
        emit(Unauthenticated());
      }
    });
  }


}
