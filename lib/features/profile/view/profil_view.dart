import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';
import 'package:overheard/features/profile/widgets/profile_grid_tab.dart';
import 'package:overheard/features/profile/widgets/profile_header_widget.dart';
import 'package:overheard/features/profile/widgets/profile_tab_bar_delegate.dart';
import 'package:overheard/main.dart';
import 'package:overheard/product/constants/product_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const int tabCount = 2;

  @override
  Widget build(BuildContext context) {
    final currentUserId = locator<FirebaseDataSource>().getCurrentUserId();
    final cubit = context.read<ProfileCubit>();

    _initializeProfile(context, cubit, currentUserId);

    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTopSettingsBar(context),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfileError) {
                      return Center(child: Text('Hata: ${state.message}'));
                    }
                    if (state is! ProfileLoaded) return const SizedBox.shrink();

                    return NestedScrollView(
                      headerSliverBuilder:
                          (context, innerBoxIsScrolled) => [
                            SliverToBoxAdapter(
                              child: ProfileHeaderWidget(
                                user: state.user,
                                postsCount: state.posts.length,
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: ProfileTabBarDelegate(
                                tabBar: TabBar(
                                  indicatorColor: ProductColors.instance.black,
                                  labelColor: ProductColors.instance.black,
                                  unselectedLabelColor:
                                      ProductColors.instance.grey,
                                  tabs: const [
                                    Tab(icon: Icon(Icons.grid_on_sharp)),
                                    Tab(icon: Icon(Icons.bookmark_outline)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                      body: TabBarView(
                        children: [
                          ProfileGridTab(
                            posts: state.posts,
                            emptyMessage: "Henüz bir paylaşım yapmadınız.",
                          ),
                          ProfileGridTab(
                            posts: state.savedPosts,
                            emptyMessage: "Henüz kaydedilmiş gönderi yok.",
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeProfile(
    BuildContext context,
    ProfileCubit cubit,
    String currentUserId,
  ) {
    bool isWrongUser = false;
    if (cubit.state is ProfileLoaded) {
      isWrongUser = (cubit.state as ProfileLoaded).user.uid != currentUserId;
    }
    if (cubit.state is ProfileInitial || isWrongUser) {
      Future.microtask(() {
        if (context.mounted) {
          if (isWrongUser) cubit.reset();
          cubit.fetchProfileData(currentUserId);
        }
      });
    }
  }

  Widget _buildTopSettingsBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () => Navigator.pushNamed(context, Routes.settings),
        icon: Icon(Icons.settings, color: ProductColors.instance.tynantBlue),
      ),
    );
  }
}
