import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/service/base_service.dart';

class HomeRepository {
  final FirebaseDataSource _firebaseDataSource;

  HomeRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  Future<List<PostModel>> getPosts() async {
    final rawData = await _firebaseDataSource.fetchPosts();

    if (rawData.isEmpty) {
      return [];
    }

    return rawData.map((data) {
      final postId = data['id'] as String;
      return PostModel.fromMap(postId, data);
    }).toList();
  }
}
