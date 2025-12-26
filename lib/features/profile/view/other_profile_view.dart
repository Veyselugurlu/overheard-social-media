import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';
import 'package:overheard/features/profile/widgets/profile_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/widget/profile_post_grid_card.dart';

class OtherProfileView extends StatelessWidget {
  final String userId;

  const OtherProfileView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ProfileCubit>()..fetchProfileData(userId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ProductColors.instance.white,
          elevation: 0.5,
          leading: BackButton(color: ProductColors.instance.black),
          title: Text(
            "Profile",
            style: TextStyle(color: ProductColors.instance.black),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(child: Text('Hata: ${state.message}'));
            }

            if (state is ProfileLoaded) {
              return Column(
                children: [
                  _buildOtherProfileHeader(
                    context,
                    state.user,
                    state.posts.length,
                  ),
                  const Divider(),
                  Expanded(
                    child:
                        state.posts.isEmpty
                            ? const Center(
                              child: Text(
                                "Bu kullanıcının henüz paylaşımı yok.",
                              ),
                            )
                            : GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                              itemCount: state.posts.length,
                              itemBuilder: (context, index) {
                                return buildProfilePostCard(
                                  context,
                                  state.posts[index],
                                );
                              },
                            ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildOtherProfileHeader(
    BuildContext context,
    UserModel user,
    int postsCount,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage:
                    user.profilePhotoUrl != null
                        ? NetworkImage(user.profilePhotoUrl!)
                        : null,
                child:
                    user.profilePhotoUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatColumn(count: postsCount.toString(), label: 'Posts'),
                    StatColumn(
                      count: user.followingCount.toString(),
                      label: 'Following',
                      ids: user.following,
                    ),
                    StatColumn(
                      count: user.followersCount.toString(),
                      label: 'Followers',
                      ids: user.followers,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
