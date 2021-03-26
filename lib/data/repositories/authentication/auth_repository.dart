abstract class AuthRepository<T> {
  Future<void> signIn();
  Future<void> signOut();
  Stream<T> authChanges();
}
