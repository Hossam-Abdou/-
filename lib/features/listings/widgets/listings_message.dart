import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_text.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../../../core/shared/widgets/skeleton_list.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';

/// Loading / error / empty placeholder for any [ApiState] list.
/// Returns null when there is data to show, so callers can do
/// `ListingsMessage.of(state, onRetry) ?? theList`.
class ListingsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final bool loading;
  final SkeletonStyle skeleton;

  const ListingsMessage._({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onRetry,
    this.loading = false,
    this.skeleton = SkeletonStyle.card,
  });

  static Widget? of<T>(ApiState<T> state, VoidCallback onRetry, {SkeletonStyle skeleton = SkeletonStyle.card}) {
    final busy = state.status == ApiStatus.initial || (state.isLoading && state.items.isEmpty);
    if (busy) {
      return ListingsMessage._(icon: Icons.hourglass_empty, title: '', loading: true, skeleton: skeleton);
    }
    if (state.status == ApiStatus.failure && state.items.isEmpty) {
      final ApiException e = state.error!;
      return ListingsMessage._(
        icon: Icons.cloud_off_outlined,
        title: LocaleKeys.listingsLoadFailed.tr(),
        subtitle: e.text,
        onRetry: onRetry,
      );
    }
    if (state.items.isEmpty) {
      return ListingsMessage._(icon: Icons.search_off, title: LocaleKeys.listingsEmpty.tr());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return SkeletonList(style: skeleton, count: skeleton == SkeletonStyle.row ? 6 : 3);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(title, style: AppTextStyles.heading4, textAlign: TextAlign.center),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                  ],
                  if (onRetry != null) ...[
                    const SizedBox(height: 12),
                    TextButton(onPressed: onRetry, child: Text(LocaleKeys.listingsRetry.tr())),
                  ],
                ],
              ),
      ),
    );
  }
}
