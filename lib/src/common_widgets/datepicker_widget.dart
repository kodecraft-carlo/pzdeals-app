import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pzdeals/src/constants/index.dart';

class DatePickerFormField extends StatefulWidget {
  final String label;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String dateFormat;
  final ValueChanged<DateTime?> onChanged;
  final bool isDense;

  const DatePickerFormField({
    super.key,
    required this.label,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.dateFormat = 'MM/dd/yyyy',
    required this.onChanged,
    this.isDense = false,
  });

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.label,
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
          errorText: _errorText,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(widget.initialDate) == _formatDate(DateTime.now())
                  ? widget.label
                  : _formatDate(widget.initialDate),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize:
                    widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
                color: PZColors.pzBlack,
              ),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      confirmText: 'Confirm',
      helpText: 'Select ${widget.label}',
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      widget.onChanged(picked);
      setState(() {
        _errorText = null;
      });
    } else {
      widget.onChanged(
          _formatDate(widget.initialDate) == _formatDate(DateTime.now())
              ? widget.initialDate
              : DateTime.now());
      setState(() {
        _errorText = 'Please select a ${widget.label}';
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat(widget.dateFormat).format(date);
  }
}
