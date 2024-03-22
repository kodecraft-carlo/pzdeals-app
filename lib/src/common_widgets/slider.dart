import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 30,
      divisions: 3,
      label: "${_currentSliderValue.round()} alerts",
      inactiveColor: PZColors.pzGrey.withOpacity(0.3),
      activeColor: PZColors.pzOrange,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
