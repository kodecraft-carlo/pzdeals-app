import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/constants/index.dart';

class SearchCancelWidget extends StatelessWidget {
  const SearchCancelWidget({super.key, required this.destinationWidget});
  final Widget destinationWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => destinationWidget));
      },
      child: const Text(
        "Cancel",
        style: TextStyle(
            color: PZColors.pzBlack,
            fontSize: Sizes.fontSizeMedium,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
