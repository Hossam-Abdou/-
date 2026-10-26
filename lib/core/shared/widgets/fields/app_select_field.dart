import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// One choice in an [AppSelectField].
class SelectOption<T> {
  final T value;
  final String label;
  const SelectOption(this.value, this.label);
}

/// A tap-to-open select: a rounded field showing the current choice that
/// opens a bottom sheet with the options (a check mark on the selected one,
/// and a search box when the list is long). Replaces the stock Material
/// dropdown popup, which is cramped on phones.
class AppSelectField<T> extends StatelessWidget {
  final T? value;
  final List<SelectOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String placeholder;
  final String? sheetTitle;
  final IconData? icon;
  final bool enabled;
  final String? errorText;

  const AppSelectField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.placeholder,
    this.sheetTitle,
    this.icon,
    this.enabled = true,
    this.errorText,
  });

  String? get _selectedLabel {
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final picked = await showModalBottomSheet<SelectOption<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _SelectSheet<T>(title: sheetTitle ?? placeholder, options: options, selected: value),
    );
    if (picked != null) onChanged(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    final label = _selectedLabel;
    final hasError = errorText != null;
    final borderColor = hasError ? AppColors.error : AppColors.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: enabled ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: enabled ? () => _open(context) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: label == null ? AppColors.textMuted : AppColors.primary),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      label ?? placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyRegular.copyWith(color: label == null ? AppColors.textMuted : AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down_rounded, color: enabled ? AppColors.textSecondary : AppColors.textMuted),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
            child: Text(errorText!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ),
      ],
    );
  }
}

class _SelectSheet<T> extends StatefulWidget {
  final String title;
  final List<SelectOption<T>> options;
  final T? selected;
  const _SelectSheet({required this.title, required this.options, required this.selected});

  @override
  State<_SelectSheet<T>> createState() => _SelectSheetState<T>();
}

class _SelectSheetState<T> extends State<_SelectSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final showSearch = widget.options.length > 8;
    final q = _query.trim().toLowerCase();
    final list = q.isEmpty ? widget.options : widget.options.where((o) => o.label.toLowerCase().contains(q)).toList();
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.7),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(alignment: AlignmentDirectional.centerStart, child: Text(widget.title, style: AppTextStyles.heading3)),
              ),
              if (showSearch)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, size: 20),
                      hintText: '...',
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final o = list[i];
                    final isSel = o.value == widget.selected;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.primaryLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          o.label,
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: isSel ? AppColors.primaryDark : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSel ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20) : null,
                        onTap: () => Navigator.of(context).pop(o),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
