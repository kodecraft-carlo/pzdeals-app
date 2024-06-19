import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/services/email_service.dart';
import 'package:pzdeals/src/services/google_sheet_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class StoreInputDialog extends ConsumerStatefulWidget {
  const StoreInputDialog({super.key});

  @override
  StoreInputDialogState createState() => StoreInputDialogState();
}

class StoreInputDialogState extends ConsumerState<StoreInputDialog> {
  EmailService emailSvc = EmailService();
  GoogleSheetService googletSheetSvc = GoogleSheetService();
  String storeName = '';

  TextEditingController dialogFieldController = TextEditingController();

  sendMail(String storeName) {
    return emailSvc.sendEmailStoreSubmission(storeName);
  }

  @override
  Widget build(BuildContext context) {
    final authUserDataState = ref.watch(authUserDataProvider);
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
              setState(() {
                storeName = dialogFieldController.text.trim();
              });
              // if (mounted) LoadingDialog.show(context);
              googletSheetSvc
                  .requestStore('?timestamp=${DateTime.now()}'
                      '&store=${dialogFieldController.text}'
                      '&email=${authUserDataState.userData?.emailAddress}'
                      '&name=${authUserDataState.userData?.firstName} ${authUserDataState.userData?.lastName}')
                  .then((value) {
                if (value == true) {
                  emailSvc.sendEmailStoreSubmission(storeName);
                  // if (mounted) LoadingDialog.hide(context);
                }
                // if (mounted) LoadingDialog.hide(context);
              });
              showSnackbarWithMessage(context, 'Store submitted. Thank you!');
              Navigator.of(context).pop();
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
