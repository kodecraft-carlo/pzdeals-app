import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class MobileNumberFieldWidget extends StatefulWidget {
  const MobileNumberFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isDense,
    required this.validator,
  });

  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<PhoneNumber>? validator;
  final bool isDense;

  @override
  _MobileNumberFieldWidgetState createState() =>
      _MobileNumberFieldWidgetState();
}

class _MobileNumberFieldWidgetState extends State<MobileNumberFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: widget.controller,
      invalidNumberMessage: 'Invalid ${widget.hintText}',
      initialCountryCode: 'US',
      cursorColor: PZColors.pzOrange,
      validator: widget.validator,
      flagsButtonPadding: EdgeInsets.only(
        left: widget.isDense ? Sizes.paddingAllSmall : Sizes.paddingAll / 2,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: PZColors.pzWhite,
        searchFieldCursorColor: PZColors.pzOrange,
        searchFieldInputDecoration: InputDecoration(
          hintText: 'Select a country..',
          filled: true,
          isDense: true,
          fillColor: PZColors.pzGrey.withOpacity(0.125),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(Sizes.paddingAll),
        ),
      ),
      dropdownIcon: const Icon(Icons.keyboard_arrow_down),
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
      ),
      style: TextStyle(
        fontSize: widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
        color: PZColors.pzBlack,
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
