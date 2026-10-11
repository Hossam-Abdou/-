import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'app_property_image.dart';
import 'full_screen_image_gallery.dart';

/// A horizontal row of a property's photos — tapping any of them
/// opens the full-screen swipeable [FullScreenImageGallery] starting
/// at that photo. Used wherever someone just needs to *view* a
/// property's photos (the customer's received-offer card, property
/// details) rather than edit them.
class PropertyImageStrip extends StatelessWidget {
  final List<String> imagePaths;
  final double thumbnailSize;

  const PropertyImageStrip({super.key, required this.imagePaths, this.thumbnailSize = 72});

  void _open(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenImageGallery(imagePaths: imagePaths, initialIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return Container(
        width: thumbnailSize,
        height: thumbnailSize,
        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Icon(Icons.home_work_outlined, color: AppColors.primaryDark, size: thumbnailSize * 0.4),
      );
    }

    return SizedBox(
      height: thumbnailSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _open(context, index),
            borderRadius: BorderRadius.circular(10),
            child: AppPropertyImage(
              path: imagePaths[index],
              width: thumbnailSize,
              height: thumbnailSize,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
