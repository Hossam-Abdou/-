import 'package:flutter/material.dart';
import 'app_property_image.dart';

/// Full-screen swipeable viewer over a property's photos, with a
/// page-count indicator. Opened with `Navigator.push` (it's a modal
/// detail view, not a primary named route) from anywhere a photo
/// thumbnail is tapped — the property form, the offer picker, or the
/// customer's received-offer card.
class FullScreenImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const FullScreenImageGallery({super.key, required this.imagePaths, this.initialIndex = 0});

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _currentIndex = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('${_currentIndex + 1} / ${widget.imagePaths.length}'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.imagePaths.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: AppPropertyImage(path: widget.imagePaths[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
