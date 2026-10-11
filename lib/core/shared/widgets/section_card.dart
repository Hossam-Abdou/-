import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Generic bordered, rounded white container. This is the same visual
/// shell used for the benefits box, pricing cards, and any future
/// form/section wrapper — keeping it in one place means radius,
/// padding, and border color never drift between screens.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? AppColors.border, width: borderWidth),
      ),
      child: child,
    );
  }
}
