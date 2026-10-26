import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../generated/locale_keys.g.dart';
import '../../theme/app_text_styles.dart';

/// Cancel / action confirmation dialog. True only when the action is chosen.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String desc,
  required String action,
  required Color color,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(title, style: AppTextStyles.heading4),
      content: Text(desc, style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(LocaleKeys.cancelButton.tr())),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(action, style: TextStyle(color: color))),
      ],
    ),
  );
  return ok == true;
}
