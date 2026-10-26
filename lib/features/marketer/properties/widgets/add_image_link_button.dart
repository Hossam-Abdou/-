import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../cubit/property_form_cubit.dart';
import 'property_dialogs.dart';

/// "Add image by link" button: asks for a link and adds it to the form's photos.
class AddImageLinkButton extends StatelessWidget {
  const AddImageLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton.icon(
        onPressed: () => showImageLinkDialog(context, isValid: context.read<PropertyFormCubit>().addImageLink),
        icon: const Icon(Icons.link, size: 18),
        label: Text(LocaleKeys.propertyAddImageLink.tr()),
      ),
    );
  }
}
