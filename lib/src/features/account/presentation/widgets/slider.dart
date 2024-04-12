import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget(
      {super.key, required this.onChanged, this.initialValue = 10});

  final void Function(double) onChanged;
  final double initialValue;
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _currentSliderValue = 10;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 30,
      min: 10,
      divisions: 2,
      label:
          "${_currentSliderValue.round() == 30 ? 'All' : _currentSliderValue.round()} alerts",
      inactiveColor: PZColors.pzGrey.withOpacity(0.3),
      activeColor: PZColors.pzOrange,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
