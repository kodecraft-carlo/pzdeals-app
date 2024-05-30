import 'package:flutter/material.dart';

class CustomScaffoldWidget extends StatelessWidget {
  const CustomScaffoldWidget(
      {super.key, required this.scaffold, required this.scrollAction});

  final Scaffold scaffold;
  final VoidCallback scrollAction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        scaffold,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).padding.top,
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: scrollAction,
          ),
        ),
      ],
    );
  }
}
