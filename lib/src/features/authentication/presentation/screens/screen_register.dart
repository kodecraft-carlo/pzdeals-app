import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/button_submit.dart';
import 'package:pzdeals/src/common_widgets/datepicker_widget.dart';
import 'package:pzdeals/src/common_widgets/dropdown_widget.dart';
import 'package:pzdeals/src/common_widgets/msisdn_field.dart';
import 'package:pzdeals/src/common_widgets/password_field.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/common_widgets/text_field.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/authentication.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_register_success.dart';
import 'package:pzdeals/src/state/auth_provider.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';
import 'package:pzdeals/src/utils/index.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String? _selectedGender;
  DateTime _birthdate = DateTime.now();
  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyInfo = GlobalKey<FormState>();

  bool _isSubmitting = false;

  int _currentStep = 0;
  String? userUID;

  bool _isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PZColors.pzWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: Sizes.screenCloseIconSize,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.all(Sizes.paddingAll),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Stack(alignment: Alignment.center, children: [
              Lottie.asset(
                key: const Key('loginScreenBlob'),
                'assets/images/lottie/pzdeals_blob_orange.json',
                width: width / 2.5,
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                key: const Key('loginScreenLogo'),
                'assets/images/pzdeals_white.png',
                height: width / 6,
                fit: BoxFit.fitWidth,
              ),
            ])),
            const SizedBox(height: Sizes.spaceBetweenSections),
            IgnorePointer(
              ignoring: _isSubmitting,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  const curve = Curves.easeInOut;
                  var tween =
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child: _currentStep == 1
                    ? Form(
                        key: _formKeyInfo,
                        child: registerInformationWidget(),
                      )
                    : Form(
                        key: _formKeyEmail,
                        child: registerEmailWidget(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget registerEmailWidget() {
    return Column(children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
            text: "Sign up start", textDisplayType: TextDisplayType.xLargeText),
      ),
      const Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
            text: "Please provide an email and password to get started!",
            textDisplayType: TextDisplayType.sectionSubTitle),
      ),
      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
      TextFieldWidget(
        hintText: 'Email Address',
        focusNode: emailFocusNode,
        nextFocusNode: passwordFocusNode,
        obscureText: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        isDense: false,
        validator: emailValidator,
      ),
      const SizedBox(height: Sizes.spaceBetweenContent),
      PasswordField(
        hintText: 'Password',
        focusNode: passwordFocusNode,
        controller: passwordController,
        isDense: false,
        validator: passwordValidator,
        onPasswordValidityChanged: (isValid) {
          setState(() {
            _isPasswordValid = isValid;
          });
        },
      ),
      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SubmitButtonWidget(
            isEnabled: _isPasswordValid && !_isSubmitting,
            buttonLabel: const Row(children: [
              Text(
                'Next',
                style: TextStyle(fontSize: Sizes.fontSizeLarge),
              ),
              Icon(Icons.trending_flat, size: Sizes.mediumIconSize)
            ]),
            onSubmit: () async {
              if (_formKeyEmail.currentState?.validate() ?? false) {
                setState(() {
                  _isSubmitting = true;
                });
                final authService = ref.watch(authProvider);
                String email = emailController.text.trim();
                String password = passwordController.text;
                Map<String, String> result =
                    await authService.registerFirebaseUser(email, password);
                if (result['code'] == 'success') {
                  setState(() {
                    _currentStep++;
                  });
                  userUID = result['message'];
                } else {
                  if (mounted) {
                    showMessageDialog(context, 'Registration Failed',
                        result['message'] ?? 'Registration failed', () {
                      Navigator.of(context).pop();
                    }, "OK");
                  }
                }
              }
              setState(() {
                _isSubmitting = false;
              });
            })
      ]),
      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
      const TextWidget(
          text: 'Already have an account?',
          textDisplayType: TextDisplayType.smallText),
      const MaterialNavigateScreen(
          childWidget: Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
            child: Text("Log in",
                style: TextStyle(
                    color: PZColors.pzOrange,
                    fontSize: Sizes.fontSizeMedium,
                    fontWeight: FontWeight.bold)),
          ),
          destinationScreen: LoginScreen())
    ]);
  }

  Widget registerInformationWidget() {
    const List<String> dropdownItems = ['Male', 'Female', 'Prefer not to say'];
    return Column(children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
            text: "Basic Information",
            textDisplayType: TextDisplayType.xLargeText),
      ),
      const Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
            text: "Let's get to know you better!",
            textDisplayType: TextDisplayType.sectionSubTitle),
      ),
      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
      TextFieldWidget(
        hintText: 'First Name',
        obscureText: false,
        controller: firstNameController,
        keyboardType: TextInputType.text,
        isDense: false,
        validator: firstnameValidator,
      ),
      const SizedBox(height: Sizes.spaceBetweenContent),
      TextFieldWidget(
        hintText: 'Last Name',
        obscureText: false,
        controller: lastNameController,
        keyboardType: TextInputType.text,
        isDense: false,
        validator: lastNameValidator,
      ),
      const SizedBox(height: Sizes.spaceBetweenContent),
      DropdownWidget(
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          dropdownLabel: 'Gender',
          dropdownItems: dropdownItems,
          validator: genderValidator),
      const SizedBox(height: Sizes.spaceBetweenContent),
      DatePickerFormField(
        label: 'Birthday',
        initialDate: _birthdate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onChanged: (DateTime? date) {
          debugPrint("date picked:$date");
          setState(() {
            _birthdate = date!;
          });
        },
      ),
      const SizedBox(height: Sizes.spaceBetweenContent),
      MobileNumberFieldWidget(
        hintText: 'Phone Number',
        controller: phoneController,
        isDense: false,
        validator: phoneNumberValidator,
      ),
      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SubmitButtonWidget(
                onSubmit: () async {
                  if (_formKeyInfo.currentState?.validate() ?? false) {
                    if (_selectedGender != null &&
                        formatDateToDisplay(_birthdate, 'MM/dd/yyyy') !=
                            formatDateToDisplay(DateTime.now(), 'MM/dd/yyyy')) {
                      setState(() {
                        _isSubmitting = true;
                      });
                      final authService = ref.watch(authProvider);
                      final userInfo = <String, dynamic>{
                        "firstName": firstNameController.text.trim(),
                        "lastName": lastNameController.text.trim(),
                        "birthDate": _birthdate.toIso8601String(),
                        "gender": _selectedGender.toString().toUpperCase(),
                        "phoneNumber": phoneController.text.trim(),
                        "uID": userUID,
                      };
                      Map<String, String> result = await authService
                          .registerAccountInfo(userInfo, userUID!);

                      if (result['code'] == 'success') {
                        if (mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SuccessfulRegistrationScreen(
                              firstName: firstNameController.text.trim(),
                            );
                          }));
                        }
                      } else {
                        if (mounted) {
                          showMessageDialog(context, 'Registration Failed',
                              result['message'] ?? 'Registration failed', () {
                            Navigator.of(context).pop();
                          }, "OK");
                        }
                      }
                    } else {
                      if (mounted) {
                        showMessageDialog(context, 'Incomplete Information',
                            'Please fill in all the required fields', () {
                          Navigator.of(context).pop();
                        }, "OK");
                      }
                    }
                  } else {
                    if (mounted) {
                      showMessageDialog(context, 'Incomplete Information',
                          'Please fill in all the required fields', () {
                        Navigator.of(context).pop();
                      }, "OK");
                    }
                  }
                  setState(() {
                    _isSubmitting = false;
                  });
                },
                buttonLabel: const Text("Complete registration",
                    style: TextStyle(fontSize: Sizes.fontSizeLarge)),
              ),
            )
          ]),
    ]);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
