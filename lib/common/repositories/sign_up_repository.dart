import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';

class SignUpRepository {
  final FirebaseDataSource _firebaseDataSource;

  SignUpRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;
  Future<void> signUpWithCredentials({
    required UserModel user,
    required String password,
  }) async {
    await _firebaseDataSource.signUp(user: user, password: password);
  }
}
