import 'package:flutter/material.dart';

class BouncingArrowIcon extends StatefulWidget {
  final double height;
  final Duration duration;
  final Widget icon;
  final MaterialColor color;
  final String bounceText;

  const BouncingArrowIcon({
    super.key,
    this.height = 30.0,
    this.duration = const Duration(milliseconds: 500),
    this.icon = const Icon(Icons.keyboard_arrow_down),
    this.color = Colors.grey,
    this.bounceText = '',
  });

  @override
  _BouncingArrowIconState createState() => _BouncingArrowIconState();
}

class _BouncingArrowIconState extends State<BouncingArrowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0.0, _controller.value * 7),
          child: child,
        );
      },
      child: SizedBox(
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.icon,
              widget.bounceText.isNotEmpty
                  ? Text(widget.bounceText,
                      style: TextStyle(fontSize: 9.0, color: widget.color))
                  : const SizedBox.shrink(),
            ],
          )),
    );
  }
}
