import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Editable strip of picked photos shown at the top of a form: each
/// photo gets a large tile with a remove button, plus a trailing
/// "add photos" tile — tapping either the empty state or the add
/// tile should open a gallery picker (multi-select) via [onAdd].
/// Used by both the marketer's property form and the customer's
/// add/edit-request form.
class MultiImagePickerField extends StatelessWidget {
  final List<String> imagePaths;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final String label;

  const MultiImagePickerField({
    super.key,
    required this.imagePaths,
    required this.onAdd,
    required this.onRemove,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text('(${imagePaths.length})', style: AppTextStyles.caption),
            ],
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...imagePaths.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10),
                      child: _PickedImageTile(path: entry.value, onRemove: () => onRemove(entry.key)),
                    ),
                  ),
              _AddPhotoTile(onTap: onAdd),
            ],
          ),
        ),
      ],
    );
  }
}

class _PickedImageTile extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;
  const _PickedImageTile({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(path),
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 110,
              height: 110,
              color: AppColors.surface,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, color: AppColors.textMuted),
            ),
          ),
        ),
        PositionedDirectional(
          top: 4,
          end: 4,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(999)),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 24, color: AppColors.textMuted),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(LocaleKeys.addPropertyPhotoHint.tr(), style: AppTextStyles.caption, textAlign: TextAlign.center, maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}
