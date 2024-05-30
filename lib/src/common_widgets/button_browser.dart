import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/constants/index.dart';

class OpenBrowserButton extends StatelessWidget {
  const OpenBrowserButton(
      {super.key, this.buttonLabel = 'See Deal', required this.url});

  final String buttonLabel;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: FilledButton(
          style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
              ),
              backgroundColor: PZColors.pzGreen,
              elevation: Sizes.buttonElevation),
          onPressed: () {
            HapticFeedback.mediumImpact();
            openBrowser(url);
          },
          child: Text(
            buttonLabel,
            style: const TextStyle(color: PZColors.pzWhite),
          ),
        )),
      ],
    );
  }
}
