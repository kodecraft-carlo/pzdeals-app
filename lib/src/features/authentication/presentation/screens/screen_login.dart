import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/button_submit.dart';
import 'package:pzdeals/src/common_widgets/divider.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/common_widgets/text_field.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/widgets/google_signin.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please provide an email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              return const LoginRequiredScreen();
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
              Center(
                  child: Stack(alignment: Alignment.center, children: [
                Lottie.asset(
                  key: const Key('loginScreenBlob'),
                  'assets/images/lottie/pzdeals_blob_orange.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  key: const Key('loginScreenLogo'),
                  'assets/images/pzdeals_white.png',
                  height: 80,
                  fit: BoxFit.fitHeight,
                ),
              ])),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              const TextWidget(
                  text: "Welcome!",
                  textDisplayType: TextDisplayType.xLargeText),
              const TextWidget(
                  text:
                      "Please login with your registered email address and password",
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
              const SizedBox(height: Sizes.spaceBetweenContent),
              TextFieldWidget(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
                isDense: false,
                validator: passwordValidator,
              ),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              Row(children: [
                Expanded(
                  child: SubmitButtonWidget(onSubmit: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final authService = ref.watch(authProvider);
                      String email = emailController.text.trim();
                      String password = passwordController.text;

                      Map<String, String> result = await authService
                          .signInEmailPassword(email, password);
                      if (result['code'] == 'success') {
                        debugPrint('User logged in successfully');
                        if (mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const NavigationWidget();
                          }));
                        }
                      } else {
                        debugPrint('Login failed: ${result['message']}');
                        if (mounted) {
                          showMessageDialog(context, 'Login Failed',
                              result['message'] ?? 'Login failed', () {
                            Navigator.of(context).pop();
                          }, 'OK');
                        }
                      }
                    }
                  }),
                )
              ]),
              const SizedBox(height: Sizes.spaceBetweenSections),
              const Center(
                  child: MaterialNavigateScreen(
                      childWidget: Text("Forgot Password?",
                          style: TextStyle(
                              color: PZColors.pzBlack,
                              fontSize: Sizes.fontSizeMedium,
                              fontWeight: FontWeight.w500)),
                      destinationScreen: ResetPasswordScreen())),
              const DividerWidget(dividerName: "Or"),
              Center(
                  child: GoogleSignInButton(
                clickableWidget: Image.asset('assets/images/logins/google.png',
                    height: Sizes.mediumIconSize, fit: BoxFit.fitHeight),
              )),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              const Center(
                  child: MaterialNavigateScreen(
                      childWidget: Text("No account yet? Sign Up",
                          style: TextStyle(
                              color: PZColors.pzOrange,
                              fontSize: Sizes.fontSizeMedium,
                              fontWeight: FontWeight.w600)),
                      destinationScreen: RegisterScreen())),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
