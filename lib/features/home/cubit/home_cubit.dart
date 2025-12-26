import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/home/repo/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit({required HomeRepository repository})
    : _repository = repository,
      super(HomeInitial());

  Future<void> fetchHomePosts() async {
    if (state is HomeLoading) return;

    emit(HomeLoading());
    try {
      final posts = await _repository.getPosts();
      emit(HomeLoaded(posts));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> sendNotificationData(String targetUserId, String message) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'receiverId': targetUserId, // Bildirimi alacak kişi
      'senderId': FirebaseAuth.instance.currentUser!.uid, // Bildirimi gönderen
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }
}
