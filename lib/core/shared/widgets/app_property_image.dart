import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Renders [path] as a network image when it's an `http(s)` URL, or a
/// local file image otherwise. Property photos in this app can be
/// either — a marketer's own device photos (local file paths from
/// `image_picker`, no backend/upload yet) or demo/remote photos — so
/// every place that displays a property photo goes through this one
/// widget instead of hardcoding `Image.file`.
class AppPropertyImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppPropertyImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final image = _isNetwork
        ? Image.network(
            path,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return _placeholder(loading: true);
            },
            errorBuilder: (context, error, stackTrace) => _placeholder(),
          )
        : Image.file(
            File(path),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _placeholder(),
          );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _placeholder({bool loading = false}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.primaryLight,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            )
          : Icon(Icons.broken_image_outlined, color: AppColors.primaryDark, size: (height ?? 48) * 0.35),
    );
  }
}
