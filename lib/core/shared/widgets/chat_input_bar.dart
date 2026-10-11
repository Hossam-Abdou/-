import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';

/// Bottom message-composer bar — a text field plus a send button.
/// [onSend] fires with the trimmed text and the field clears itself;
/// empty submissions are ignored. Shared by both chat threads.
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: _submit,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.send, size: 20, color: AppColors.textOnPrimary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(999)),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: LocaleKeys.chatInputHint.tr(),
                    hintStyle: AppTextStyles.bodyRegular,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
