import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/filter/cubit/filter_state.dart';
import 'package:overheard/features/search/cubit/search_cubit.dart';
import 'package:overheard/features/search/cubit/search_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/widget/my_appbar.dart';
import 'package:overheard/product/widget/user_list_card.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(
        titleWidget: _buildSearchField(context),
        centerTitle: false,
        backgroundColor: ProductColors.instance.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ProductColors.instance.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, Routes.filter);

              if (result != null && result is FilterState) {
                if (context.mounted) {
                  context.read<SearchCubit>().applyFilters(result);
                }
              }
            },
            child: Text(
              "Filters",
              style: TextStyle(
                color: ProductColors.instance.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _buildSearchAndFilterResults(),
    );
  }

  Widget _buildSearchAndFilterResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final activeList =
            state.isFilterMode ? state.filterResults : state.searchResults;

        if (!state.isFilterMode && state.searchQuery.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 60,
                  color: ProductColors.instance.blue.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Keşfetmeye Başlayın!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Bir kullanıcı adı arayın veya filtreleyin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ProductColors.instance.grey),
                ),
              ],
            ),
          );
        }

        if (activeList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 60,
                  color: ProductColors.instance.grey400,
                ),
                const SizedBox(height: 16),
                Text(
                  "Kullanıcı bulunamadı.",
                  style: TextStyle(
                    color: ProductColors.instance.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.isFilterMode
                      ? "Bu filtrelere uygun kimse bulunamadı."
                      : "Aradığınız isimde bir kullanıcı bulunamadı.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ProductColors.instance.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const ProductPadding.allLow(),
          itemCount: activeList.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = activeList[index];
            return UserListCard(
              user: user,
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    Routes.otherProfile,
                    arguments: user.uid,
                  ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ProductColors.instance.grey200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        autofocus: true,
        onChanged: (val) => context.read<SearchCubit>().updateQuery(val),
        decoration: const InputDecoration(
          hintText: "Search by Name or Handle",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
