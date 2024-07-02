import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
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
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFieldButton(
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

class TextFieldButton extends StatefulWidget {
  const TextFieldButton(
      {super.key,
      required this.onButtonPressed,
      required this.buttonLabel,
      required this.textFieldHint,
      this.textfieldIcon = Icons.search,
      this.hasIcon = true,
      this.isAutoFocus = false,
      this.validateEmail = false,
      required this.textController});

  final VoidCallback onButtonPressed;
  final String buttonLabel;
  final String textFieldHint;
  final IconData textfieldIcon;
  final bool hasIcon;
  final bool isAutoFocus;
  final TextEditingController textController;
  final bool validateEmail;

  @override
  _TextFieldButtonState createState() => _TextFieldButtonState();
}

class _TextFieldButtonState extends State<TextFieldButton> {
  bool isActionEnabled = false;

  @override
  void initState() {
    super.initState();
    isActionEnabled = widget.textController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      height: 44,
      padding: const EdgeInsets.only(left: Sizes.paddingLeftSmall),
      decoration: BoxDecoration(
          border: Border.all(color: PZColors.pzGrey.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
          color: PZColors.pzLightGrey),
      child: Row(
        children: [
          if (widget.hasIcon)
            Icon(
              widget.textfieldIcon,
              color: PZColors.pzOrange,
              size: Sizes.textFieldIconSize,
            ),
          Expanded(
            child: TextField(
              autofocus: widget.isAutoFocus,
              controller: widget.textController,
              onChanged: (value) {
                if (widget.validateEmail) {
                  setState(() {
                    isActionEnabled = isEmailAddressValid(value) ? true : false;
                  });
                } else {
                  setState(() {
                    isActionEnabled = value.isNotEmpty;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: widget.textFieldHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.only(left: Sizes.paddingAllSmall * .5),
                suffixIcon: widget.textController.text.isNotEmpty
                    ? GestureDetector(
                        child: const Icon(Icons.cancel, color: PZColors.pzGrey),
                        onTap: () {
                          widget.textController.clear();
                          setState(() {
                            isActionEnabled = false;
                          });
                        },
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 35,
                ),
              ),
              style: const TextStyle(
                  fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: !isActionEnabled
                  ? MaterialStateProperty.all<Color>(PZColors.pzGrey)
                  : MaterialStateProperty.all<Color>(PZColors.pzOrange),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: Sizes.paddingAll)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.textFieldCornerRadius),
                    bottomRight: Radius.circular(Sizes.textFieldCornerRadius)),
              )),
            ),
            onPressed: !isActionEnabled || widget.textController.text.isEmpty
                ? null
                : () {
                    widget.onButtonPressed();
                    widget.textController.clear();
                    setState(() {
                      isActionEnabled = false;
                    });
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
            child: Text(
              widget.buttonLabel,
              style: const TextStyle(color: PZColors.pzWhite),
            ),
          ),
          const SizedBox(width: 1)
        ],
      ),
    );
  }
}
