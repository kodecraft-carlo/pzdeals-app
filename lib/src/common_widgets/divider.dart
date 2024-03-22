import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, required this.dividerName});

  final String dividerName;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Divider(
              height: 1,
              thickness: 1,
              color: PZColors.pzGrey.withOpacity(.5),
            )),
            Padding(
              padding: const EdgeInsets.all(Sizes.paddingAll),
              child: Text(
                dividerName,
                style: const TextStyle(
                    fontSize: Sizes.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: PZColors.pzGrey),
              ),
            ),
            Expanded(
                child: Divider(
              height: 1,
              thickness: 1,
              color: PZColors.pzGrey.withOpacity(.5),
            )),
          ],
        )
      ],
    );
  }
}
