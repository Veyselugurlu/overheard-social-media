import 'package:flutter/material.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/profile/repo/profile_repository.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/widget/user_list_card.dart';

class UserListView extends StatelessWidget {
  final String title;
  final List<String> userIds;

  const UserListView({super.key, required this.title, required this.userIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: ProductColors.instance.black, fontSize: 18),
        ),
        backgroundColor: ProductColors.instance.white,
        iconTheme: IconThemeData(color: ProductColors.instance.black),
        elevation: 0.5,
      ),
      body:
          userIds.isEmpty
              ? const Center(child: Text("Henüz kimse yok."))
              : FutureBuilder<List<UserModel>>(
                future: locator<ProfileRepository>().getUsersFromList(userIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Yüklenirken bir hata oluştu."),
                    );
                  }

                  final users = snapshot.data ?? [];
                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder:
                        (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserListCard(
                        user: user,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.otherProfile,
                            arguments: user.uid,
                          );
                        },
                      );
                    },
                  );
                },
              ),
    );
  }
}
