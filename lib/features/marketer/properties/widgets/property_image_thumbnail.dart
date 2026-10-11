import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Shows a property's cover photo from its local file path, or a
/// placeholder icon when none has been picked yet. Used by the
/// property list, the offer property-picker, and the property form.
///
/// When [extraCount] is greater than 0, a "+N" badge overlays the
/// corner so it's clear there are more photos than just this cover.
class PropertyImageThumbnail extends StatelessWidget {
  final String? imagePath;
  final double size;
  final double borderRadius;
  final int extraCount;

  const PropertyImageThumbnail({
    super.key,
    required this.imagePath,
    this.size = 64,
    this.borderRadius = 10,
    this.extraCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: size,
            height: size,
            color: AppColors.primaryLight,
            alignment: Alignment.center,
            child: path != null && path.isNotEmpty
                ? Image.file(
                    File(path),
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    // Local file may have been cleared (cache/temp dir) —
                    // fall back to the placeholder instead of crashing.
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.home_work_outlined, color: AppColors.primaryDark, size: size * 0.4),
                  )
                : Icon(Icons.home_work_outlined, color: AppColors.primaryDark, size: size * 0.4),
          ),
        ),
        if (extraCount > 0)
          PositionedDirectional(
            end: 2,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(999)),
              child: Text('+$extraCount', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 10)),
            ),
          ),
      ],
    );
  }
}
