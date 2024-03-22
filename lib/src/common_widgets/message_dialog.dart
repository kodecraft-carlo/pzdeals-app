import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPrimaryActionPressed;
  final VoidCallback? onSecondaryActionPressed;
  final String primaryActionText;
  final String? secondaryActionText;
  final bool hasSecondaryAction;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onPrimaryActionPressed,
    this.onSecondaryActionPressed,
    required this.primaryActionText,
    this.secondaryActionText,
    this.hasSecondaryAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      surfaceTintColor: Colors.transparent,
      backgroundColor: PZColors.pzWhite,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: Sizes.fontSizeLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onPrimaryActionPressed,
          child: Text(
            primaryActionText,
            style: const TextStyle(color: PZColors.pzOrange),
          ),
        ),
        hasSecondaryAction
            ? TextButton(
                onPressed: onSecondaryActionPressed,
                child: Text(
                  secondaryActionText!,
                  style: const TextStyle(color: PZColors.pzBlack),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
