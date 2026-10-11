import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// One row on a chat list screen: initials avatar, other party's
/// name, last-message preview, timestamp, and an unread dot. Shared
/// by both the client and marketer conversation lists.
class ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool unread;
  final String? subtitle;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.onTap,
    this.unread = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.substring(0, 1) : '?';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (unread)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                )
              else
                const SizedBox(width: 8),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(time, style: AppTextStyles.caption),
                        Flexible(
                          child: Text(
                            name,
                            style: unread ? AppTextStyles.heading4 : AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.caption, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: AppTextStyles.bodySmall.copyWith(color: unread ? AppColors.textPrimary : AppColors.textSecondary),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: Text(initial, style: AppTextStyles.heading4.copyWith(color: AppColors.primaryDark)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
