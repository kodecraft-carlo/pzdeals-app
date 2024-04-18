import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/index.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.paddingAll),
      child: SliderTheme(
        data: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.never,
          thumbShape: _ThumbShape(),
        ),
        child: Slider(
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
        ),
      ),
    );
  }
}

class _ThumbShape extends RoundSliderThumbShape {
  final _indicatorShape = const PaddleSliderValueIndicatorShape();

  const _ThumbShape();

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      textDirection: textDirection,
    );
    _indicatorShape.paint(
      context,
      center,
      activationAnimation: const AlwaysStoppedAnimation(1),
      enableAnimation: enableAnimation,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      value: value,
// test different testScaleFactor to find your best fit
      textScaleFactor: 0.6,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
    );
  }
}
