import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: 'Set % Off threshold',
          fillColor: PZColors.pzGrey.withOpacity(0.125),
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(10)),
      style: const TextStyle(
          fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
    );
  }
}
