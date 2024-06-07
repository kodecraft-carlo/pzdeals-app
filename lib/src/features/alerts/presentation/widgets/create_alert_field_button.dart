import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';
import 'package:pzdeals/src/features/authentication/presentation/widgets/dialog_login_required.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/state/authentication_provider.dart';

class CreateAlertFieldButton extends ConsumerStatefulWidget {
  const CreateAlertFieldButton(
      {super.key,
      required this.buttonLabel,
      required this.textFieldHint,
      this.textfieldIcon = Icons.search,
      this.hasIcon = true,
      this.isAutoFocus = false,
      required this.textController});

  final String buttonLabel;
  final String textFieldHint;
  final IconData textfieldIcon;
  final bool hasIcon;
  final bool isAutoFocus;
  final TextEditingController textController;

  @override
  CreateAlertFieldButtonState createState() => CreateAlertFieldButtonState();
}

class CreateAlertFieldButtonState
    extends ConsumerState<CreateAlertFieldButton> {
  bool isActionEnabled = false;
  bool isSuccessful = false;

  @override
  void initState() {
    super.initState();
    isActionEnabled = widget.textController.text.isNotEmpty;
  }

  void onButtonPressed() {
    if (widget.textController.text.isNotEmpty) {
      if (ref.read(authUserDataProvider).userData == null) {
        showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: true,
          builder: (context) => ScaffoldMessenger(
            child: Builder(
              builder: (context) => Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: GestureDetector(
                    onTap: () {},
                    child: const LoginRequiredDialog(),
                  ),
                ),
              ),
            ),
          ),
        );
        debugPrint('User not authenticated');
        return;
      }
      if (ref.read(keywordsProvider).addKeywordLocally(
          KeywordData(
              id: 0, keyword: widget.textController.text.trim().toLowerCase()),
          'input')) {
        // showSnackbarWithMessage(context, 'Keyword added');
        widget.textController.clear();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        HapticFeedback.mediumImpact();
        setState(() {
          isSuccessful = true;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            isSuccessful = false;
          });
        });
      } else {
        showSnackbarWithMessage(context, 'Keyword already exists');
      }
    }
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
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: isSuccessful
                    ? const Icon(Icons.check,
                        color: PZColors.pzGreen, size: Sizes.textFieldIconSize)
                    : Icon(widget.textfieldIcon,
                        color: PZColors.pzOrange,
                        size: Sizes.textFieldIconSize)),
          // Icon(
          //   widget.textfieldIcon,
          //   color: isSuccessful ? PZColors.pzGreen : PZColors.pzOrange,
          //   size: Sizes.textFieldIconSize,
          // ),
          Expanded(
            child: TextField(
              autofocus: widget.isAutoFocus,
              controller: widget.textController,
              onChanged: (value) {
                setState(() {
                  isActionEnabled = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: widget.textFieldHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingAllSmall),
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
                  minWidth: 40,
                ),
              ),
              style: const TextStyle(
                  fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(isSuccessful
                  ? PZColors.pzGreen
                  : !isActionEnabled
                      ? PZColors.pzGrey
                      : PZColors.pzOrange),
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
                    onButtonPressed();
                    widget.textController.clear();
                    setState(() {
                      isActionEnabled = false;
                    });
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
            child: Text(
              isSuccessful ? 'Success!' : 'Create',
              style: const TextStyle(color: PZColors.pzWhite),
            ),
          ),
          const SizedBox(width: 1)
        ],
      ),
    );
  }
}
