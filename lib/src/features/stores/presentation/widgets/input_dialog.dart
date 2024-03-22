import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/services/email_service.dart';

class StoreInputDialog extends ConsumerStatefulWidget {
  const StoreInputDialog({super.key});

  @override
  _StoreInputDialogState createState() => _StoreInputDialogState();
}

class _StoreInputDialogState extends ConsumerState<StoreInputDialog> {
  EmailService emailSvc = EmailService();
  TextEditingController dialogFieldController = TextEditingController();

  Future<bool> sendMail(String storeName) async {
    return emailSvc.sendEmailStoreSubmission(storeName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: PZColors.pzWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(), // Pushes the icon to the right
          IconButton(
            icon: const Icon(
              Icons.close,
              size: Sizes.largeIconSize,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      contentPadding: const EdgeInsets.only(
        left: Sizes.paddingAll,
        right: Sizes.paddingAll,
        bottom: Sizes.paddingAll,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Don't see your favorite store? Submit it here!",
            style: TextStyle(
              fontSize: Sizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Sizes.paddingBottomSmall),
          TextFieldButton(
            textController: dialogFieldController,
            onButtonPressed: () async {
              if (mounted) LoadingDialog.show(context);
              if (await sendMail(dialogFieldController.text)) {
                if (mounted) LoadingDialog.hide(context);
                showSnackbarWithMessage(context, 'Store submitted. Thank you!');
                Navigator.of(context).pop();
              }
            },
            buttonLabel: 'Submit',
            textFieldHint: 'Store name or website..',
            hasIcon: false,
            isAutoFocus: true,
          ),
        ],
      ),
    );
  }
}
