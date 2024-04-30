import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/index.dart';

class DropdownWidget extends StatefulWidget {
  final String? initialValue;
  final void Function(String?) onChanged;
  final String dropdownLabel;
  final List<String> dropdownItems;
  final bool isDense;
  final FormFieldValidator<String>? validator;

  const DropdownWidget({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.dropdownLabel,
    required this.dropdownItems,
    this.isDense = false,
    this.validator,
  });

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return isIOS()
        ? GestureDetector(
            onTap: () => showCupertinoModalPopup(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => Container(
                height: 230,
                padding: const EdgeInsets.only(top: 6.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          onPressed: () {
                            widget.onChanged(_selectedValue);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Done',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: PZColors.pzOrange)),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          selectionOverlay:
                              CupertinoPickerDefaultSelectionOverlay(
                            background: PZColors.pzOrange.withOpacity(0.1),
                          ),
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _selectedValue = widget.dropdownItems[index];
                            });
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: widget.dropdownItems
                                .indexOf(_selectedValue ?? ''),
                          ),
                          children: widget.dropdownItems.map((String item) {
                            return Center(
                              child: Text(
                                item,
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PZColors.pzGrey.withOpacity(0.125),
                borderRadius:
                    BorderRadius.circular(Sizes.textFieldCornerRadius),
              ),
              child: Text(_selectedValue ?? widget.dropdownLabel),
            ),
          )
        : DropdownButtonFormField<String>(
            value: _selectedValue,
            isExpanded: false,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
                widget.onChanged(value);
              });
            },
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              hintText: widget.dropdownLabel,
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize:
                    widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
                color: PZColors.pzGrey,
              ),
              fillColor: PZColors.pzGrey.withOpacity(0.125),
              filled: true,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Sizes.textFieldCornerRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(
                widget.isDense ? Sizes.paddingAllSmall : Sizes.paddingAll,
              ),
              isDense: widget.isDense,
            ),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize:
                  widget.isDense ? Sizes.fontSizeSmall : Sizes.fontSizeMedium,
              color: PZColors.pzBlack,
            ),
            items: widget.dropdownItems
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
  }

  bool isIOS() {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }
}
