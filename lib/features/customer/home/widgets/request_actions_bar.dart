import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/widgets/app_snack_bar.dart';
import '../../../../core/shared/widgets/confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../requests/cubit/requests_cubit.dart';
import '../models/property_request.dart';

/// Bottom bar of the request details: edit, close (while open) and delete.
class RequestActionsBar extends StatelessWidget {
  final PropertyRequest request;
  const RequestActionsBar({super.key, required this.request});

  Future<void> _close(BuildContext context) async {
    final cubit = context.read<RequestsCubit>();
    final yes = await confirmDialog(
      context,
      title: LocaleKeys.closeRequestConfirmTitle.tr(),
      desc: LocaleKeys.closeRequestConfirmDesc.tr(),
      action: LocaleKeys.closeRequestButton.tr(),
      color: AppColors.primaryDark,
    );
    if (!yes) return;
    if (!await cubit.closeRequest(request.id) && context.mounted) {
      showAppSnackBar(context, cubit.state.error!.text, isError: true);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<RequestsCubit>();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final yes = await confirmDialog(
      context,
      title: LocaleKeys.deleteRequestConfirmTitle.tr(),
      desc: LocaleKeys.deleteRequestConfirmDesc.tr(),
      action: LocaleKeys.deleteRequestButton.tr(),
      color: AppColors.error,
    );
    if (!yes) return;
    if (await cubit.delete(request.id)) {
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(LocaleKeys.requestDeleted.tr())));
    } else if (context.mounted) {
      showAppSnackBar(context, cubit.state.error!.text, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.border))),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.editRequest, arguments: request.id),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(LocaleKeys.editRequestButton.tr()),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  ),
                ),
                if (request.status != PropertyRequestStatus.closed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _close(context),
                      icon: const Icon(Icons.lock_outline, size: 16),
                      label: Text(LocaleKeys.closeRequestButton.tr()),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryDark, side: const BorderSide(color: AppColors.primaryDark)),
                    ),
                  ),
                ],
              ],
            ),
            TextButton.icon(
              onPressed: () => _delete(context),
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
              label: Text(LocaleKeys.deleteRequestButton.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}
