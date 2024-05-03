import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class MaterialNavigateScreen extends StatelessWidget {
  final Widget childWidget;
  final Widget destinationScreen;

  const MaterialNavigateScreen(
      {super.key, required this.childWidget, required this.destinationScreen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          Platform.isIOS
              ? CupertinoPageRoute(
                  builder: (context) => destinationScreen,
                )
              : MaterialPageRoute(
                  builder: (context) => destinationScreen,
                ),
        );
      },
      child: childWidget,
    );
  }
}
