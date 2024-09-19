import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class AnimatedGradientProgressBar extends StatefulWidget {
  const AnimatedGradientProgressBar({super.key});

  @override
  AnimatedGradientProgressBarState createState() =>
      AnimatedGradientProgressBarState();
}

class AnimatedGradientProgressBarState
    extends State<AnimatedGradientProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 1400), // Set the duration for the animation loop
      vsync: this,
    )..repeat(); // Repeats indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.0, // Adjust height
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade300,
                  Colors.orange.shade300,
                  Colors.orange.shade700,
                  PZColors.pzOrange,
                  Colors.orange.shade700,
                  Colors.orange.shade300,
                  Colors.orange.shade300,
                ],
                begin: Alignment(-1.0 + _controller.value * 2, 0.0),
                end: Alignment(1.0 + _controller.value * 2, 0.0),
                tileMode:
                    TileMode.repeated, // Makes the gradient loop endlessly
              ),
            ),
          );
        },
      ),
    );
  }
}
