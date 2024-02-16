import 'package:flutter/material.dart';

class SlideUpDialog extends StatelessWidget {
  const SlideUpDialog(
      {super.key, required this.childWidget, required this.slideUpDialog});

  final Widget childWidget;
  final Widget slideUpDialog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.easeInOut,
                ),
              ),
              child: slideUpDialog,
            );
          },
        );
      },
      child: childWidget,
    );
  }
}
