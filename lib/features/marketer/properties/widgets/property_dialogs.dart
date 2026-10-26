import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Asks for an image link. Returns the text typed (already trimmed) or null.
/// [isValid] decides whether the link is accepted (the dialog stays open and
/// shows an error otherwise).
Future<String?> showImageLinkDialog(BuildContext context, {required bool Function(String) isValid}) async {
  final controller = TextEditingController();
  final link = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      String? error;
      return StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(LocaleKeys.propertyAddImageLink.tr(), style: AppTextStyles.heading4),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            autofocus: true,
            decoration: InputDecoration(hintText: LocaleKeys.propertyImageLinkHint.tr(), errorText: error, errorMaxLines: 2),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(LocaleKeys.cancelButton.tr())),
            TextButton(
              onPressed: () {
                final v = controller.text.trim();
                if (!isValid(v)) {
                  setLocal(() => error = LocaleKeys.propertyImageLinkInvalid.tr());
                  return;
                }
                Navigator.of(dialogContext).pop(v);
              },
              child: Text(LocaleKeys.okButton.tr()),
            ),
          ],
        ),
      );
    },
  );
  controller.dispose();
  return link;
}

Future<void> showPropertySavedDialog(BuildContext context, {required bool edited}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(LocaleKeys.propertySavedSuccessTitle.tr(), style: AppTextStyles.heading4),
        ],
      ),
      content: Text(
        (edited ? LocaleKeys.propertyUpdatedSuccessDesc : LocaleKeys.propertyAddedSuccessDesc).tr(),
        style: AppTextStyles.bodyRegular,
        textAlign: TextAlign.start,
      ),
      actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(LocaleKeys.okButton.tr()))],
    ),
  );
}

Future<bool> confirmDeleteProperty(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(LocaleKeys.deletePropertyConfirmTitle.tr(), style: AppTextStyles.heading4),
      content: Text(LocaleKeys.deletePropertyConfirmDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(LocaleKeys.cancelButton.tr())),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(LocaleKeys.deletePropertyButton.tr(), style: const TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
  return confirmed == true;
}
