import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

extension AppSnackbar on BuildContext {
  void showSuccessSnackbar(String message) {
    _show(message, Colors.green.shade700);
  }

  void showErrorSnackbar(String message) {
    _show(message, AppColors.error);
  }

  void showWarningSnackbar(String message) {
    _show(message, AppColors.warning);
  }

  void showInfoSnackbar(String message) {
    _show(message, AppColors.primary);
  }

  void _show(String message, Color color) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
