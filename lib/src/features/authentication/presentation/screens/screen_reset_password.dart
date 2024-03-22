import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/button_submit.dart';
import 'package:pzdeals/src/common_widgets/text_field.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_reset_password_success.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please provide an email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth / 1.2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PZColors.pzWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: PZColors.pzWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: Sizes.screenCloseIconSize,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }));
          },
        ),
      ),
      body: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.all(Sizes.paddingAll),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              Center(
                child: SvgPicture.asset(
                  key: const Key('loginScreenLogo'),
                  'assets/images/forgot.svg',
                  width: width,
                  fit: BoxFit.fitHeight,
                ),
              ),
              // Center(
              //     child: Stack(alignment: Alignment.center, children: [
              //   Lottie.asset(
              //     key: const Key('loginScreenBlob'),
              //     'assets/images/lottie/pzdeals_blob_orange.json',
              //     width: 200,
              //     height: 200,
              //     fit: BoxFit.fill,
              //   ),
              //   Image.asset(
              //     key: const Key('loginScreenLogo'),
              //     'assets/images/pzdeals_white.png',
              //     height: 80,
              //     fit: BoxFit.fitHeight,
              //   ),
              // ])),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              const TextWidget(
                  text: "Forgot Password",
                  textDisplayType: TextDisplayType.xLargeText),
              const TextWidget(
                  text:
                      "Enter your registered email address to receive an email with instructions on how to reset your password.",
                  textDisplayType: TextDisplayType.sectionSubTitle),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              TextFieldWidget(
                hintText: 'Email Address',
                obscureText: false,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isDense: false,
                validator: emailValidator,
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              Row(children: [
                Expanded(
                  child: SubmitButtonWidget(onSubmit: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final authService = ref.watch(authProvider);
                      Map<String, String> result =
                          await authService.resetFirebaseUserPassword(
                              emailController.text.trim());
                      if (result['code'] == 'success') {
                        if (mounted) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SuccessfulPasswordResetScreen(
                              emailAddress: emailController.text.trim(),
                            );
                          }));
                        }
                      } else {
                        if (mounted) {
                          showMessageDialog(
                              context,
                              'Message',
                              result['message'] ??
                                  'Sorry. We are unable to send the reset password link to your email address at the moment',
                              () {
                            Navigator.of(context).pop();
                          }, "OK");
                        }
                      }
                    }
                  }),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
