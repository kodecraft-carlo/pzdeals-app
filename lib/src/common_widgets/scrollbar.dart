import 'package:flutter/material.dart';

class ScrollbarWidget extends StatelessWidget {
  const ScrollbarWidget(
      {super.key, required this.child, this.scrollController});

  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(5),
      interactive: true,
      minThumbLength: 50,
      thickness: 5,
      minOverscrollLength: 50,
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}
