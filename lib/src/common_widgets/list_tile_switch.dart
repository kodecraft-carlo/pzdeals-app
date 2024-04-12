import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class ListTileWithSwitchWidget extends StatefulWidget {
  const ListTileWithSwitchWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title, subtitle;
  final bool value;
  final void Function(bool) onChanged;

  @override
  State<ListTileWithSwitchWidget> createState() =>
      _ListTileWithSwitchWidgetState();
}

class _ListTileWithSwitchWidgetState extends State<ListTileWithSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title,
          style: const TextStyle(
              fontSize: Sizes.listTitleFontSize, fontWeight: FontWeight.w500)),
      subtitle: Text(widget.subtitle,
          style: const TextStyle(fontSize: Sizes.listSubtitleFontSize)),
      trailing: Switch(
        value: widget.value,
        onChanged: (bool? value) {
          widget.onChanged(value!);
        },
        activeColor: PZColors.pzWhite,
        activeTrackColor: PZColors.pzOrange,
        inactiveThumbColor: PZColors.pzWhite,
        inactiveTrackColor: PZColors.pzGrey.withOpacity(0.4),
        trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.transparent;
          }
          return Colors.transparent;
        }),
      ),
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
