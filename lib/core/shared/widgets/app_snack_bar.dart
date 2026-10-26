import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// One place to show a snack bar, so every screen looks and behaves the same.
/// Replaces any snack bar that is still showing. Errors are red.
void showAppSnackBar(BuildContext context, String message, {bool isError = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
      ),
    );
}
