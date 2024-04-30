import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.isDense,
      this.validator,
      this.focusNode,
      this.nextFocusNode,
      this.isReadonly = false});

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isDense;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isReadonly;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      cursorColor: PZColors.pzOrange,
      obscureText: _isObscure && widget.obscureText,
      controller: widget.controller,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
      validator: widget.validator != null
          ? (value) {
              if (value != null && value.isNotEmpty) {
                return null;
              }
              return widget.validator!(value);
            }
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: PZColors.pzGrey.withOpacity(0.125),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.all(
          widget.isDense ? Sizes.paddingAllSmall : Sizes.paddingAll,
        ),
        isDense: widget.isDense,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: PZColors.pzGrey.withOpacity(0.9),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
      style: TextStyle(
        fontSize: widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
        color: PZColors.pzBlack,
      ),
      keyboardType: widget.keyboardType,
    );
  }
}
