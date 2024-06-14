import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';

class CommonSliderWidget extends StatefulWidget {
  const CommonSliderWidget({super.key});

  @override
  State<CommonSliderWidget> createState() => CommonSliderWidgetState();
}

class CommonSliderWidgetState extends State<CommonSliderWidget> {
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
