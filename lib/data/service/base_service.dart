import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:overheard/data/models/user_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Giriş sırasında bir hata oluştu.');
    }
  }

  //kulalncı var mı
  Future<bool> doesUserExistByEmail(String email) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint("Firestore e-posta kontrol hatası: $e");
      return false;
    }
  }

  Future<void> signUp({
    required UserModel user,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': user.name,
          'gender': user.gender,
          'email': user.email,
          'age': user.age,
          'city': user.city.toUpperCase(),
          'bdate': user.bdate,
          'followersCount': 0,
          'followingCount': 0,
          'followers': [],
          'following': [],
          'savedPosts': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Firebase Auth sırasında bir hata oluştu.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      debugPrint("Doğrulama e-postası gönderildi.");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint("Şifre sıfırlama e-postası gönderildi: $email");
    } on FirebaseAuthException catch (e) {
      debugPrint("Şifre sıfırlama hatası: ${e.message}");
      rethrow;
    }
  }

  String getCurrentUserId() {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception("Kullanıcı oturum açmamış. Post kaydı yapılamaz.");
    }
    return userId;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final snapshot =
        await _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  Future<String> uploadPostPhoto(File file, String userId) async {
    final storageRef = _storage.ref().child(
      'user_posts/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> checkCurrentUser() async {
    return _auth.currentUser != null;
  }

  Future<void> savePostToFirestore(Map<String, dynamic> postData) async {
    try {
      await _firestore.collection('posts').add({
        ...postData,
        'timestamp': FieldValue.serverTimestamp(),
      });
      final String userId = postData['userId'] as String;
      final String targetProfile =
          (postData['targetProfileId'] ?? 'myself').toString();

      await _firestore.collection('users').doc(userId).update({
        'postTypes': FieldValue.arrayUnion([targetProfile]),
      });
    } on FirebaseException catch (e) {
      throw Exception('Post kaydetme hatası: ${e.message}');
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> fetchUserPosts(String userId) async {
    final snapshot =
        await _firestore
            .collection('posts')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  //  Tek bir Post'u ID ile çeker
  Future<Map<String, dynamic>?> fetchPostById(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();

    if (!doc.exists) return null;

    // ID'yi Map'e ekliyoruz
    return doc.data()!..['id'] = doc.id;
  }

  //  Yorumu Firestore'a kaydet
  Future<void> saveCommentToFirestore({
    required String postId,
    required String text,
    required String userName,
  }) async {
    final currentUserId = getCurrentUserId();

    try {
      //  Yeni yorum dokümanını kaydet
      await _firestore.collection('comments').add({
        'postId': postId,
        'userId': currentUserId,
        'text': text,
        'name': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Yorum kaydetme hatası: ${e.message}');
    }
  }

  // Yorumları çekme metodu
  Future<List<Map<String, dynamic>>> fetchCommentsForPost(String postId) async {
    final snapshot =
        await _firestore
            .collection('comments')
            .where('postId', isEqualTo: postId)
            .orderBy('timestamp', descending: false)
            .get();

    final List<Map<String, dynamic>> commentsWithUserData = [];

    for (final doc in snapshot.docs) {
      final commentData = doc.data();
      final String userId = commentData['userId'].toString();

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      commentsWithUserData.add({
        ...commentData,
        'id': doc.id,
        'name': userData?['name'] ?? 'Bilinmeyen Kullanıcı',
        'profilePhotoUrl': userData?['profilePhotoUrl'],
      });
    }
    return commentsWithUserData;
  }

  // beğeni syaısı
  Future<Map<String, dynamic>> toggleCommentLike({
    required String commentId,
  }) async {
    final userId = getCurrentUserId();
    final commentRef = _firestore.collection('comments').doc(commentId);

    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(commentRef);
      if (!snapshot.exists) throw Exception("Yorum bulunamadı.");

      final data = snapshot.data()!;
      final List<dynamic> likedUsers = (data['likedUsers'] as List?) ?? [];
      int currentLikes = (data['likesCount'] as int?) ?? 0;

      bool isLiked;
      if (likedUsers.contains(userId)) {
        // Beğeniyi geri çek
        likedUsers.remove(userId);
        currentLikes--;
        isLiked = false;
      } else {
        // Beğen
        likedUsers.add(userId);
        currentLikes++;
        isLiked = true;
      }

      transaction.update(commentRef, {
        'likedUsers': likedUsers,
        'likesCount': currentLikes,
      });

      return {'likesCount': currentLikes, 'isLiked': isLiked};
    });
  }

  // tkaipe etme kısmı

  Future<bool> toggleFollowUser(String targetUserId) async {
    final currentUserId = getCurrentUserId();

    // Kullanıcının takip durumunu kontrol et
    final isCurrentlyFollowing = await isUserFollowing(
      currentUserId,
      targetUserId,
    );

    final userRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    final transactionResult = await _firestore.runTransaction((
      transaction,
    ) async {
      // Takip etme/bırakma işlemini yap
      if (isCurrentlyFollowing) {
        // Takibi Bırak
        transaction.update(userRef, {
          'following': FieldValue.arrayRemove([targetUserId]),
          'followingCount': FieldValue.increment(-1),
        });
        transaction.update(targetUserRef, {
          'followers': FieldValue.arrayRemove([currentUserId]),
          'followersCount': FieldValue.increment(-1),
        });
        return false; // Yeni durum: Takip etmiyor
      } else {
        // Takip Et
        transaction.update(userRef, {
          'following': FieldValue.arrayUnion([targetUserId]),
          'followingCount': FieldValue.increment(1),
        });
        transaction.update(targetUserRef, {
          'followers': FieldValue.arrayUnion([currentUserId]),
          'followersCount': FieldValue.increment(1),
        });
        return true; // Takip ediyor
      }
    });

    return transactionResult;
  }

  Future<bool> isUserFollowing(
    String currentUserId,
    String targetUserId,
  ) async {
    final doc = await _firestore.collection('users').doc(currentUserId).get();
    final List<dynamic> following = (doc.data()?['following'] as List?) ?? [];
    return following.contains(targetUserId);
  }

  //flag ksııjmalrı
  Future<Map<String, int>> togglePostFlag({
    required String postId,
    required String flagType,
  }) async {
    final userId = getCurrentUserId();
    final postRef = _firestore.collection('posts').doc(postId);

    // Firestore transaction işlemi
    return await _firestore.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);
      if (!postSnapshot.exists) {
        throw Exception("Oylanacak gönderi bulunamadı.");
      }

      final data = postSnapshot.data()!;

      final userListKey = '${flagType}Users';
      final countKey = '${flagType}Count';

      final List<dynamic> userList = (data[userListKey] as List?) ?? [];
      final int currentCount = data[countKey] as int? ?? 0;

      int newCount = currentCount;
      bool newStatus; // Oy eklendi, False: Oy çıkarıldı

      if (userList.contains(userId)) {
        //  Kullanıcı daha önce oy vermiş -> Oyu geri çek
        newCount = currentCount - 1;
        transaction.update(postRef, {
          userListKey: FieldValue.arrayRemove([userId]),
          countKey: newCount,
        });
        newStatus = false;
      } else {
        newCount = currentCount + 1;
        transaction.update(postRef, {
          userListKey: FieldValue.arrayUnion([userId]),
          countKey: newCount,
        });
        newStatus = true;
      }
      return {'newCount': newCount, 'isVoted': newStatus ? 1 : 0};
    });
  }

  Future<String> uploadProfilePhoto(File file, String userId) async {
    try {
      final storageRef = _storage.ref().child('profile_photos/$userId.jpg');

      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});

      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'profilePhotoUrl': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      throw Exception('Profil fotoğrafı yükleme hatası: ${e.toString()}');
    }
  }

  Future<void> deletePostFromFirestore(String postId, String? photoUrl) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();

      if (photoUrl != null && photoUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(photoUrl).delete();
        } catch (e) {
          debugPrint("Storage silme hatası (dosya zaten yok olabilir): $e");
        }
      }
    } catch (e) {
      throw Exception('Gönderi silinirken hata oluştu: ${e.toString()}');
    }
  }

  // stream
  Stream<List<Map<String, dynamic>>> userPostsStream(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList(),
        );
  }

  //settings kısmı
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Oturum açmış kullanıcı yok.");

    final String uid = user.uid;

    try {
      final userPosts =
          await _firestore
              .collection('posts')
              .where('userId', isEqualTo: uid)
              .get();

      for (final postDoc in userPosts.docs) {
        final photoUrl = postDoc.data()['photoUrl'] as String?;
        if (photoUrl != null && photoUrl.isNotEmpty) {
          try {
            await _storage.refFromURL(photoUrl).delete();
          } catch (e) {
            debugPrint("Görsel silinirken hata (atlandı): $e");
          }
        }
        await postDoc.reference.delete();
      }

      try {
        await _storage.ref('profile_photos/$uid.jpg').delete();
      } catch (e) {
        debugPrint("Profil fotosu yok veya silinemedi.");
      }

      await _firestore.collection('users').doc(uid).delete();

      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
          "Güvenlik nedeniyle bu işlem için tekrar giriş yapmalısınız.",
        );
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Hesap tamamen silinemedi: $e");
    }
  }

  //kaydetme islemi
  Future<bool> toggleSavePost(String postId) async {
    final userId = getCurrentUserId();
    final userRef = _firestore.collection('users').doc(userId);

    return await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) throw Exception("Kullanıcı bulunamadı.");

      final List<String> savedPosts = List<String>.from(
        (userSnapshot.data()?['savedPosts'] as List?) ?? [],
      );
      bool isSaving;

      if (savedPosts.contains(postId)) {
        // Zaten varsa çıkar
        transaction.update(userRef, {
          'savedPosts': FieldValue.arrayRemove([postId]),
        });
        isSaving = false;
      } else {
        // Yoksa ekle
        transaction.update(userRef, {
          'savedPosts': FieldValue.arrayUnion([postId]),
        });
        isSaving = true;
      }
      return isSaving;
    });
  }

  // kaydet alanına llaydeidlenleri gosterme
  Future<List<Map<String, dynamic>>> fetchPostsByIds(
    List<String> postIds,
  ) async {
    if (postIds.isEmpty) return [];

    final snapshot =
        await _firestore
            .collection('posts')
            .where(FieldPath.documentId, whereIn: postIds)
            .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  Future<List<Map<String, dynamic>>> fetchUsersByIds(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: userIds)
            .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  //kayıt dinleme
  Stream<UserModel?> userStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThanOrEqualTo: '$query\uf8ff')
              .limit(20)
              .get();

      return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
    } catch (e) {
      throw Exception("Arama hatası: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchFollowingUsers(
    List<String> followingIds,
  ) async {
    if (followingIds.isEmpty) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: followingIds)
            .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  Future<List<Map<String, dynamic>>> fetchFollowers(String targetUserId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .where('following', arrayContains: targetUserId)
            .get();
    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  //filitreleme
  Future<List<Map<String, dynamic>>> fetchUsersWithFilters({
    String? city,
    String? gender,
    String? postType,
    required int minAge,
    required int maxAge,
  }) async {
    try {
      Query query = _firestore.collection('users');

      if (city != null && city.trim().isNotEmpty && city != "All") {
        query = query.where('city', isEqualTo: city.trim().toUpperCase());
      }

      if (gender != null && gender != "All") {
        query = query.where('gender', isEqualTo: gender);
      }
      if (postType != null && postType != "All") {
        final String dbValue = (postType == "self") ? "myself" : "someone_else";
        query = query.where('postTypes', arrayContains: dbValue);
      }

      // Yaş Aralığı
      query = query
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('age', isLessThanOrEqualTo: maxAge);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>..['id'] = doc.id;
      }).toList();
    } catch (e) {
      throw Exception("Filtreleme hatası: $e");
    }
  }

  //servşse
  Future<void> updateUserDetails(
    String userId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception("Profil güncelleme hatası: $e");
    }
  }

  Future<void> sendNotificationToFirestore({
    required String receiverId,
    required String message,
    String? postId,
  }) async {
    try {
      final currentUserId = getCurrentUserId();
      await _firestore.collection('notifications').add({
        'receiverId': receiverId,
        'senderId': currentUserId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'postId': postId,
      });
    } catch (e) {
      throw Exception('Bildirim gönderilemedi: $e');
    }
  }
}
