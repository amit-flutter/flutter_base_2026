import 'package:flutter/material.dart';
import 'app_button.dart';

class AppDialog {
  AppDialog._();

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelLabel),
            ),
            AppButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
              expanded: false,
            ),
          ],
        ),
      );

  static Future<String?> prompt(
    BuildContext context, {
    required String title,
    String? hint,
    String confirmLabel = 'Submit',
    String cancelLabel = 'Cancel',
  }) =>
      showDialog<String>(
        context: context,
        builder: (ctx) {
          final controller = TextEditingController();
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(cancelLabel),
              ),
              AppButton(
                label: confirmLabel,
                onPressed: () => Navigator.of(ctx).pop(controller.text),
                expanded: false,
              ),
            ],
          );
        },
      );
}
