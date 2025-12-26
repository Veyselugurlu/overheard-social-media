import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //izn istedik
  Future<void> initNotifications() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final String? token = await _fcm.getToken();
      print("Cihaz Token: $token");
    }
  }

  //tokeni kaydet
  Future<void> updateTokenInFirestore() async {
    final String? token = await _fcm.getToken();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (token != null && userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'deviceToken': token,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
