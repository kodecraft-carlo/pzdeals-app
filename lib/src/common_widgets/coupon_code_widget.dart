import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/constants/index.dart';

class CouponCodeWidget extends StatelessWidget {
  final String text;
  final String? url;
  final BuildContext? buildcontext;
  final String couponType;

  const CouponCodeWidget(
      {super.key,
      required this.text,
      this.url,
      this.buildcontext,
      this.couponType = 'store'});

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
            color: couponType == 'store' ? Colors.orange[200] : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(text,
                style: TextStyle(
                  color:
                      couponType == 'store' ? Colors.black : PZColors.pzOrange,
                  fontWeight: couponType == 'store'
                      ? FontWeight.normal
                      : FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }
}
