import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/utils/field_validation/index.dart';

class CommonInputDialog extends StatefulWidget {
  const CommonInputDialog(
      {super.key,
      required this.dialogMessage,
      required this.inputHint,
      required this.snackbarMessage,
      required this.dialogFieldController,
      required this.onButtonPressed,
      this.buttonText = 'Submit',
      this.isButtonOnly = false});

  final String dialogMessage;
  final String inputHint;
  final String snackbarMessage;
  final TextEditingController dialogFieldController;
  final Function onButtonPressed;
  final String buttonText;
  final bool isButtonOnly;

  @override
  CommonInputDialogState createState() => CommonInputDialogState();
}

class CommonInputDialogState extends State<CommonInputDialog> {
  bool isInputValid = false;
  void submitButton(BuildContext context) {
    // if (mounted) LoadingDialog.sxhow(context);
    widget.onButtonPressed();
    showSnackbarWithMessage(context, widget.snackbarMessage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Platform.isIOS
        //     ? CupertinoAlertDialog(
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               widget.dialogMessage,
        //               style: const TextStyle(
        //                 fontSize: Sizes.fontSizeMedium,
        //               ),
        //             ),
        //             const SizedBox(height: Sizes.paddingBottomSmall),
        //             widget.isButtonOnly
        //                 ? Center(
        //                     child: notifyButton(),
        //                   )
        //                 : CupertinoTextField(
        //                     controller: widget.dialogFieldController,
        //                     clearButtonMode: OverlayVisibilityMode.editing,
        //                     placeholder: widget.inputHint,
        //                     keyboardType: TextInputType.emailAddress,
        //                     autofocus: false,
        //                     cursorColor: CupertinoColors.activeBlue,
        //                     style: const TextStyle(fontSize: Sizes.fontSizeLarge),
        //                     textInputAction: TextInputAction.done,
        //                     onChanged: (value) {
        //                       if (isEmailAddressValid(value)) {
        //                         setState(() {
        //                           isInputValid = true;
        //                         });
        //                       } else {
        //                         setState(() {
        //                           isInputValid = false;
        //                         });
        //                       }
        //                     },
        //                     inputFormatters: [
        //                       TextInputFormatter.withFunction(
        //                         (oldValue, newValue) {
        //                           return newValue.copyWith(
        //                             text: newValue.text.toLowerCase(),
        //                           );
        //                         },
        //                       ),
        //                     ],
        //                     // onSubmitted: (value) {
        //                     //   submitButton(context);
        //                     // },
        //                   ),
        //             widget.isButtonOnly
        //                 ? const SizedBox.shrink()
        //                 : Padding(
        //                     padding:
        //                         const EdgeInsets.only(top: Sizes.paddingTopSmall),
        //                     child: Row(
        //                       children: [
        //                         Expanded(
        //                             child: CupertinoButton(
        //                           color: CupertinoColors.activeBlue,
        //                           padding: EdgeInsets.zero,
        //                           onPressed: isInputValid == false
        //                               ? null
        //                               : () => submitButton(context),
        //                           child: Text(
        //                             widget.buttonText,
        //                             style: const TextStyle(
        //                                 fontSize: Sizes.fontSizeMedium),
        //                           ),
        //                         ))
        //                       ],
        //                     ),
        //                   )
        //           ],
        //         ),
        //       )
        //     :

        AlertDialog(
      titlePadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: PZColors.pzWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
      ),
      contentPadding: const EdgeInsets.all(Sizes.paddingAll),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.dialogMessage,
            style: const TextStyle(
              fontSize: Sizes.fontSizeMedium,
            ),
          ),
          const SizedBox(height: Sizes.paddingBottomSmall),
          widget.isButtonOnly
              ? Row(
                  children: [Expanded(child: notifyButton())],
                )
              : TextFieldButton(
                  textController: widget.dialogFieldController,
                  onButtonPressed: () async {
                    submitButton(context);
                  },
                  buttonLabel: widget.buttonText,
                  textFieldHint: widget.inputHint,
                  hasIcon: false,
                  isAutoFocus: true,
                  validateEmail: true,
                ),
        ],
      ),
    );
  }

  Widget notifyButton() {
    return
        // Platform.isIOS
        //     ? Row(
        //         children: [
        //           Expanded(
        //             child: CupertinoButton(
        //                 color: CupertinoColors.activeBlue,
        //                 child: Text(
        //                   widget.buttonText,
        //                   style: const TextStyle(fontSize: Sizes.fontSizeMedium),
        //                 ),
        //                 onPressed: () => submitButton(context)),
        //           )
        //         ],
        //       )
        //     :
        MaterialButton(
            color: PZColors.pzOrange,
            textColor: PZColors.pzWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
            ),
            onPressed: () => submitButton(context),
            child: Text(widget.buttonText));
  }
}
