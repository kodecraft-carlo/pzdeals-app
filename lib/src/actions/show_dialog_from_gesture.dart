import 'package:flutter/material.dart';

class ShowDialogWidgetFromGesture extends StatelessWidget {
  final Widget content;
  final Widget childWidget;
  final bool barrierDismissible;

  const ShowDialogWidgetFromGesture(
      {super.key,
      required this.content,
      required this.childWidget,
      this.barrierDismissible = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: barrierDismissible,
          builder: (context) {
            return content;
          },
        );
      },
      child: childWidget,
    );
  }
}
