import 'package:flutter/material.dart';

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const ProfileTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(ProfileTabBarDelegate oldDelegate) => false;
}
