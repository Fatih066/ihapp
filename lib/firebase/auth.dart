import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.toString().trim(), password: password.toString().trim());
    return user.user?.uid;
  }

  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.toString().trim(),
      password: password.toString().trim(),
    );
    return userCredential.user?.uid;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
