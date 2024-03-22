import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

class FilterByPriceWidget extends ConsumerStatefulWidget {
  const FilterByPriceWidget({super.key});
  @override
  _FilterByPriceWidgetState createState() => _FilterByPriceWidgetState();
}

class _FilterByPriceWidgetState extends ConsumerState<FilterByPriceWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController minAmount = TextEditingController();
  TextEditingController maxAmount = TextEditingController();
  FocusNode minFocus = FocusNode();
  FocusNode maxFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    minAmount.text = ref.read(searchFilterProvider).minAmount == 0
        ? ""
        : ref.read(searchFilterProvider).minAmount.toString();
    maxAmount.text = ref.read(searchFilterProvider).maxAmount == 100000000000
        ? '~'
        : ref.read(searchFilterProvider).maxAmount == 0
            ? ''
            : ref.read(searchFilterProvider).maxAmount.toString();
  }

  void setTextfieldValues(int min, dynamic max) {
    minAmount.text = min.toString();
    maxAmount.text = max.toString();

    ref.read(searchFilterProvider).setMinAmount(min);
    ref.read(searchFilterProvider).setMaxAmount(max);
  }

  String? validatePrice(String? value) {
    if (value != null && value.isNotEmpty) {
      final minValue = int.tryParse(value);
      final maxValue = int.tryParse(maxAmount.text);
      if (minValue != null && maxValue != null && minValue > maxValue) {
        return 'Min amount cannot be greater than Max amount';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: minAmount,
                  focusNode: minFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(maxFocus);
                    ref
                        .read(searchFilterProvider)
                        .setMinAmount(int.tryParse(minAmount.text) ?? 0);
                  },
                  onChanged: (value) => ref
                      .read(searchFilterProvider)
                      .setMinAmount(int.tryParse(value) ?? 0),
                  decoration: InputDecoration(
                    hintText: 'Min',
                    fillColor: PZColors.pzGrey.withOpacity(0.125),
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Sizes.textFieldCornerRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall),
                  ),
                  style: const TextStyle(
                      fontSize: Sizes.textFieldFontSize,
                      color: PZColors.pzBlack),
                ),
              ),
              const Icon(
                Icons.horizontal_rule_sharp,
                color: PZColors.pzBlack,
              ),
              Expanded(
                child: TextFormField(
                  controller: maxAmount,
                  focusNode: maxFocus,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  onEditingComplete: () => ref
                      .read(searchFilterProvider)
                      .setMaxAmount(maxAmount.text != '~'
                          ? int.tryParse(maxAmount.text)
                          : '~'),
                  onChanged: (value) => ref
                      .read(searchFilterProvider)
                      .setMaxAmount(int.tryParse(value) ?? 0),
                  decoration: InputDecoration(
                    hintText: 'Max',
                    fillColor: PZColors.pzGrey.withOpacity(0.125),
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Sizes.textFieldCornerRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall),
                  ),
                  style: const TextStyle(
                      fontSize: Sizes.textFieldFontSize,
                      color: PZColors.pzBlack),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Sizes.spaceBetweenContentSmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setTextfieldValues(1, 49);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes
                            .buttonBorderRadius), // Adjust the radius as needed
                      ),
                      backgroundColor: PZColors.pzLightGrey),
                  child: const Text(
                    '\$1 - 49',
                    style: TextStyle(color: PZColors.pzBlack),
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.paddingAllSmall,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setTextfieldValues(50, 99);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes
                            .buttonBorderRadius), // Adjust the radius as needed
                      ),
                      backgroundColor: PZColors.pzLightGrey),
                  child: const Text(
                    '\$50 - 99',
                    style: TextStyle(color: PZColors.pzBlack),
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.paddingAllSmall,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setTextfieldValues(99, '~');
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes
                            .buttonBorderRadius), // Adjust the radius as needed
                      ),
                      backgroundColor: PZColors.pzLightGrey),
                  child: const Text(
                    '\$99 up',
                    style: TextStyle(color: PZColors.pzBlack),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
