import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class SubmitButtonWidget extends StatefulWidget {
  final Widget buttonLabel;
  final Function onSubmit;
  final bool isEnabled;

  const SubmitButtonWidget({
    super.key,
    this.buttonLabel =
        const Text('Submit', style: TextStyle(fontSize: Sizes.fontSizeLarge)),
    required this.onSubmit,
    this.isEnabled = true,
  });

  @override
  _SubmitButtonWidgetState createState() => _SubmitButtonWidgetState();
}

class _SubmitButtonWidgetState extends State<SubmitButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.isEnabled && !_isLoading
          ? () async {
              setState(() {
                _isLoading = true;
              });
              await widget.onSubmit();
              setState(() {
                _isLoading = false;
              });
            }
          : null,
      style: FilledButton.styleFrom(
        enableFeedback: true,
        fixedSize: const Size.fromHeight(50),
        backgroundColor: PZColors.pzOrange,
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.paddingAll, vertical: Sizes.paddingAllSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
        ),
      ),
      child: _isLoading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                      padding: EdgeInsets.all(6),
                      child: CircularProgressIndicator.adaptive()),
                ),
                SizedBox(width: Sizes.paddingAllSmall),
                Text(
                  'Please wait..',
                  style: TextStyle(fontSize: Sizes.fontSizeLarge),
                )
              ],
            )
          : widget.buttonLabel,
    );
  }
}
