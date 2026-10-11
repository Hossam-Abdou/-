import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The 4-dot progress header at the top of the create/edit-request
/// wizard (نوع -> موقع -> تفاصيل -> تأكيد). [currentStep] is 1-based.
/// Renders left-to-right in source order; under RTL `Directionality`
/// (the app's default) step 1 lands on the right and step 4 on the
/// left, matching the Figma flow, with no manual mirroring needed.
class RequestStepProgress extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const RequestStepProgress({super.key, required this.currentStep, required this.labels});

  @override
  Widget build(BuildContext context) {
    final total = labels.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(total * 2 - 1, (i) {
        if (i.isEven) {
          final step = i ~/ 2 + 1;
          return _StepDot(step: step, label: labels[step - 1], currentStep: currentStep);
        }
        final leftStep = (i - 1) ~/ 2 + 1;
        final isDone = leftStep < currentStep;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Container(height: 2, color: isDone ? AppColors.primary : AppColors.border),
          ),
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final String label;
  final int currentStep;

  const _StepDot({required this.step, required this.label, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDone = step < currentStep;
    final isCurrent = step == currentStep;
    final isActive = isDone || isCurrent;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? AppColors.primary : AppColors.border, width: 1.5),
          ),
          child: isDone
              ? const Icon(Icons.check, size: 15, color: Colors.white)
              : Text(
                  '$step',
                  style: AppTextStyles.caption.copyWith(
                    color: isActive ? Colors.white : AppColors.textMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isCurrent ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
