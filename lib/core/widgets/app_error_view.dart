import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class AppErrorView extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    required this.message,
    this.actionLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              AppSpacing.hLg,
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              if (onRetry != null) ...[
                AppSpacing.hLg,
                AppButton(
                  label: actionLabel ?? 'Retry',
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      );
}
