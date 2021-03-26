import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository<User> {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<void> signIn() async {
    return await _firebaseAuth.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
