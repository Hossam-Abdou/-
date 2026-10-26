import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/widgets/app_snack_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../listings/cubit/listings_cubit.dart';
import 'property_dialogs.dart';

/// Outlined "Delete property" button: asks to confirm, deletes the listing
/// through [MyListingsCubit] and closes the screen.
class DeletePropertyButton extends StatelessWidget {
  final String propertyId;
  const DeletePropertyButton({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final listings = context.read<MyListingsCubit>();
        final navigator = Navigator.of(context);
        if (!await confirmDeleteProperty(context)) return;
        final ok = await listings.delete(propertyId);
        if (ok) {
          navigator.pop();
        } else if (context.mounted) {
          showAppSnackBar(context, listings.state.error?.text ?? LocaleKeys.apiErrGeneric.tr(), isError: true);
        }
      },
      icon: const Icon(Icons.delete_outline, size: 18),
      label: Text(LocaleKeys.deletePropertyButton.tr()),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
