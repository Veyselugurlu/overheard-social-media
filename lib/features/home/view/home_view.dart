import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/home/view/for_you_feed_view.dart';
import 'package:overheard/features/search/cubit/search_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/widget/my_appbar.dart';

import '../../map/view/map_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBarWidget(
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: ProductColors.instance.black),
              onPressed: () {
                context.read<SearchCubit>().clearSearch();
                Navigator.pushNamed(context, Routes.search);
              },
            ),
            IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: ProductColors.instance.black,
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: ProductColors.instance.darkRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.notificationsList);
              },
            ),
          ],
          title: "Over Heads",
          backgroundColor: ProductColors.instance.white,

          bottom: TabBar(
            indicatorColor: ProductColors.instance.tynantBlue,
            labelColor: ProductColors.instance.tynantBlue,
            unselectedLabelColor: ProductColors.instance.grey,
            tabs: const [Tab(text: "For You"), Tab(text: "Map")],
          ),
        ),
        body: const TabBarView(
          children: [Center(child: ForYouFeedView()), Center(child: MapView())],
        ),
      ),
    );
  }
}
