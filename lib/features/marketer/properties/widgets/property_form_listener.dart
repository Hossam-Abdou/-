import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_text.dart';
import '../../../../core/shared/widgets/app_snack_bar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubit/property_form_cubit.dart';
import 'property_dialogs.dart';

/// Reacts to the one-shot results of [PropertyFormCubit]: success dialog and
/// closing the screen, error snack bars.
class PropertyFormListener extends StatelessWidget {
  final Widget child;
  const PropertyFormListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyFormCubit, PropertyFormState>(
      listenWhen: (previous, current) => current.event != null,
      listener: (context, state) async {
        final navigator = Navigator.of(context);
        switch (state.event) {
          case PropertyFormEvent.saved:
            await showPropertySavedDialog(context, edited: context.read<PropertyFormCubit>().isEdit);
            navigator.pop();
          case PropertyFormEvent.deleted:
            navigator.pop();
          case PropertyFormEvent.uploadFailed:
            showAppSnackBar(context, LocaleKeys.propertyUploadFailed.tr(), isError: true);
          case PropertyFormEvent.failed:
            showAppSnackBar(context, state.error?.text ?? LocaleKeys.apiErrGeneric.tr(), isError: true);
          case null:
            break;
        }
      },
      child: child,
    );
  }
}
