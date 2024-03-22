import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.isDense,
      this.validator,
      required this.onPasswordValidityChanged,
      this.focusNode});

  final String hintText;
  final TextEditingController controller;
  final bool isDense;
  final FormFieldValidator<String>? validator;
  final ValueChanged<bool> onPasswordValidityChanged;
  final FocusNode? focusNode;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField>
    with SingleTickerProviderStateMixin {
  bool _isObscure = true;
  String _passwordVal = '';
  late AnimationController _animationController;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;
  bool _isLengthValid = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          cursorColor: PZColors.pzOrange,
          obscureText: _isObscure,
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator != null
              ? (value) {
                  if (value != null && value.isNotEmpty) {
                    return null;
                  }
                  return widget.validator!(value);
                }
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _passwordVal = '';
              });
            } else {
              _passwordVal = value;
              if (value.contains(RegExp(r'[A-Z]'))) {
                setState(() {
                  _hasUppercase = true;
                });
              } else {
                setState(() {
                  _hasUppercase = false;
                });
              }

              if (value.contains(RegExp(r'[a-z]'))) {
                setState(() {
                  _hasLowercase = true;
                });
              } else {
                setState(() {
                  _hasLowercase = false;
                });
              }

              if (value.contains(RegExp(r'[0-9]'))) {
                setState(() {
                  _hasDigits = true;
                });
              } else {
                setState(() {
                  _hasDigits = false;
                });
              }

              if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_+=-]'))) {
                setState(() {
                  _hasSpecialCharacters = true;
                });
              } else {
                setState(() {
                  _hasSpecialCharacters = false;
                });
              }

              if (value.length >= 8) {
                setState(() {
                  _isLengthValid = true;
                });
              } else {
                setState(() {
                  _isLengthValid = false;
                });
              }

              if (_calculateProgress() == 1.0) {
                widget.onPasswordValidityChanged(true);
              } else {
                widget.onPasswordValidityChanged(false);
              }
            }
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: PZColors.pzGrey.withOpacity(0.125),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(
              widget.isDense ? Sizes.paddingAllSmall : Sizes.paddingAll,
            ),
            isDense: widget.isDense,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: PZColors.pzGrey.withOpacity(0.9),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
          style: TextStyle(
            fontSize:
                widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
            color: PZColors.pzBlack,
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 8),
        _passwordVal.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
                  value: _calculateProgress(),
                  backgroundColor: Colors.grey[300],
                  valueColor: _progressColor(),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: Sizes.spaceBetweenContent),
        _passwordVal.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    textWidget('Minimum 8 characters', _isLengthValid),
                    textWidget('Contains an uppercase letter', _hasUppercase),
                    textWidget('Contains a lowercase letter', _hasLowercase),
                    textWidget('Contains a digit', _hasDigits),
                    textWidget(
                        'Contains a special character', _hasSpecialCharacters),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget textWidget(String text, bool isTrue) {
    return Row(
      children: [
        Icon(
          isTrue ? Icons.check : Icons.close,
          color: isTrue ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: Sizes.fontSizeSmall,
            color: PZColors.pzGrey,
          ),
        ),
      ],
    );
  }

  double _calculateProgress() {
    // Calculate the overall progress based on your criteria
    int totalCriteria = 5; // Total number of criteria
    int fulfilledCriteria = 0;

    if (_hasUppercase) fulfilledCriteria++;
    if (_hasLowercase) fulfilledCriteria++;
    if (_hasDigits) fulfilledCriteria++;
    if (_hasSpecialCharacters) fulfilledCriteria++;
    if (_isLengthValid) fulfilledCriteria++;

    return fulfilledCriteria / totalCriteria;
  }

  // Determine the color of the progress bar
  AlwaysStoppedAnimation<Color> _progressColor() {
    // Return a color based on the overall progress
    double progress = _calculateProgress();
    if (progress >= 0.8) {
      return const AlwaysStoppedAnimation<Color>(Colors.green);
    } else if (progress >= 0.5) {
      return const AlwaysStoppedAnimation<Color>(Colors.orange);
    } else {
      return const AlwaysStoppedAnimation<Color>(Colors.red);
    }
  }
}
