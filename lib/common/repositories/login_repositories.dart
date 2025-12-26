import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';

class LoginRepository {
  final FirebaseDataSource _firebaseDataSource;

  LoginRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  Future<void> signInWithCredentials(String email, String password) async {
    await _firebaseDataSource.signIn(email, password);
  }

  Future<void> signUpWithCredentials({
    required UserModel user,
    required String password,
  }) async {
    await _firebaseDataSource.signUp(user: user, password: password);
  }

  Future<void> signOut() async {
    await _firebaseDataSource.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    try {
      return await _firebaseDataSource.checkCurrentUser();
    } catch (e) {
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _firebaseDataSource.sendPasswordResetEmail(email);
  }

  Future<bool> checkUserExistence(String email) async {
    return _firebaseDataSource.doesUserExistByEmail(email);
  }
}
