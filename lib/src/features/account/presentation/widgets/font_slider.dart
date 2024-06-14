import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/constants/index.dart';

class FontSliderWidget extends StatefulWidget {
  const FontSliderWidget(
      {super.key, required this.onChanged, this.initialValue = 1});

  final void Function(double) onChanged;
  final double initialValue;
  @override
  State<FontSliderWidget> createState() => _FontSliderWidgetState();
}

class _FontSliderWidgetState extends State<FontSliderWidget> {
  late double _currentSliderValue = 1;

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
          // trackShape: CustomTrackShape(),
        ),
        child: Slider(
          value: _currentSliderValue,
          max: 1.3,
          min: 1.0,
          divisions: 4,
          label: "${_currentSliderValue == 1.3 ? 'Max' : _currentSliderValue}",
          inactiveColor: PZColors.pzGrey.withOpacity(0.3),
          activeColor: PZColors.pzOrange,
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
            HapticFeedback.lightImpact();
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
    Offset? secondaryOffset, // Add this line
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
      secondaryOffset: secondaryOffset, // Add this line
    );

    const int divisions = 4;
    final double trackWidth = parentBox.size.width;
    final double dx = trackWidth / divisions;

    final Paint paint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.black
      ..style = PaintingStyle.fill;

    for (int i = 1; i < divisions; i++) {
      final double x = offset.dx + dx * i;
      context.canvas.drawLine(
        Offset(x, offset.dy + 10),
        Offset(x, offset.dy + parentBox.size.height - 10),
        paint,
      );
    }
  }
}
