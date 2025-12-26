import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/home/cubit/home_cubit.dart';
import 'package:overheard/features/home/cubit/home_state.dart';
import 'package:overheard/product/widget/post_grid_tile_card.dart';

class ForYouFeedView extends StatefulWidget {
  const ForYouFeedView({super.key});

  @override
  State<ForYouFeedView> createState() => _ForYouFeedViewState();
}

class _ForYouFeedViewState extends State<ForYouFeedView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchHomePosts();
  }

  static const List<WovenGridTile> _wovenGridPattern = [
    WovenGridTile(1.0),
    WovenGridTile(
      5 / 7,
      crossAxisRatio: 0.9,
      alignment: AlignmentDirectional.centerEnd,
    ),
  ];
  static const List<double> _patternRatios = [1.0, 5 / 7];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text("Hata oluştu: ${state.message}"));
        }

        final List<PostModel> posts = state is HomeLoaded ? state.posts : [];
        if (posts.isEmpty) {
          return const Center(child: Text("Henüz bir gönderi yok."));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.custom(
            gridDelegate: SliverWovenGridDelegate.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              pattern: _wovenGridPattern,
            ),
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
              final PostModel post = posts[index];
              final int patternIndex = index % _wovenGridPattern.length;
              final WovenGridTile patternTile = _wovenGridPattern[patternIndex];
              final double ratio = _patternRatios[patternIndex];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.detailPost,
                    arguments: post.id,
                  );
                },
                child: PostGridTile(
                  post: post,
                  gridTile: patternTile,
                  mainRatio: ratio,
                ),
              );
            }, childCount: posts.length),
          ),
        );
      },
    );
  }
}
