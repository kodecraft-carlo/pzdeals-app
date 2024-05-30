import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';

class CouponCodeWidget extends StatelessWidget {
  final String text;
  final String? url;
  final BuildContext? buildcontext;

  const CouponCodeWidget(
      {super.key, required this.text, this.url, this.buildcontext});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Clipboard.setData(ClipboardData(text: text));
        showSnackbarWithMessage(buildcontext ?? context, 'Coupon code copied');
        if (url != null && url != '') openBrowser(url!);
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            color: Colors.orange[200],
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
