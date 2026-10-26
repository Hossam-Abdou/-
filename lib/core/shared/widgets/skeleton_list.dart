import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';

enum SkeletonStyle { card, row }

/// Loading placeholder: a few grey "ghost" items with a shimmer, shaped like
/// the real cards, instead of a spinner. Built on `skeletonizer` — the Text
/// and Icon widgets below only give it the shapes to turn into bones.
class SkeletonList extends StatelessWidget {
  final int count;
  final SkeletonStyle style;
  final EdgeInsetsGeometry padding;

  const SkeletonList({
    super.key,
    this.count = 3,
    this.style = SkeletonStyle.card,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(baseColor: Color(0xFFE5E7EB), highlightColor: Color(0xFFF3F4F6)),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            for (var i = 0; i < count; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: style == SkeletonStyle.card ? const _CardGhost() : const _RowGhost(),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardGhost extends StatelessWidget {
  const _CardGhost();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 120, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 12),
          const Text('Property title goes here', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('District, City', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text('1,500,000 EGP', style: TextStyle(fontSize: 15)),
              Spacer(),
              Text('3 rooms', style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowGhost extends StatelessWidget {
  const _RowGhost();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 24, child: Icon(Icons.person)),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Last message preview text here', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const Text('10:30', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
