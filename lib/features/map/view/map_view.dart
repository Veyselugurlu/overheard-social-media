import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/features/home/cubit/home_cubit.dart';
import 'package:overheard/features/home/cubit/home_state.dart';
import 'package:overheard/features/map/widgets/map_user_marker.dart';
import 'package:overheard/product/constants/product_colors.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(38.9637, 35.2433),
              initialZoom: 6,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.overheard',
              ),
              MarkerLayer(
                markers:
                    state.posts
                        .map((post) {
                          if (post.latitude == null || post.longitude == null) {
                            return null;
                          }

                          return Marker(
                            point: LatLng(post.latitude!, post.longitude!),
                            width: 60,
                            height: 60,
                            child: GestureDetector(
                              onTap: () => _showPostPreview(context, post),
                              child: UserMarkerWidget(photoUrl: post.photoUrl),
                            ),
                          );
                        })
                        .whereType<Marker>()
                        .toList(),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showPostPreview(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.detailPost, arguments: post.id);
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ProductColors.instance.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ProductColors.instance.black26,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Küçük Resim
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.photoUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yazılar
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${post.city}, ${post.district ?? ''}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ProductColors.instance.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: ProductColors.instance.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
