import 'package:flutter/material.dart';

class ShowDialogWidget extends StatelessWidget {
  final Widget content;
  final Widget childWidget;

  const ShowDialogWidget(
      {super.key, required this.content, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return content;
          },
        );
      },
      child: childWidget,
    );
  }
}
