import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: ProductColors.instance.white,
        foregroundColor: ProductColors.instance.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .where('receiverId', isEqualTo: currentUserId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Henüz bir bildirim yok."));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: ProductColors.instance.customBlue1
                      .withValues(alpha: 0.1),
                  child: Icon(
                    Icons.favorite,
                    color: ProductColors.instance.customBlue1,
                  ),
                ),
                title: Text(
                  (data['message'] as String?) ?? "Yeni bir bildirim",
                ),

                subtitle: Text(
                  data['timestamp'] != null
                      ? (data['timestamp'] as Timestamp)
                          .toDate()
                          .toString()
                          .substring(0, 16)
                      : "Az önce",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
