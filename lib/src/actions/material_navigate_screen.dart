import 'package:flutter/material.dart';

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
            MaterialPageRoute(
              builder: (context) => destinationScreen,
            ));
      },
      child: childWidget,
    );
  }
}
