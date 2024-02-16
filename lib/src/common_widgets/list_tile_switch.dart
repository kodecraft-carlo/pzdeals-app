import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class ListTileWithSwitchWidget extends StatefulWidget {
  const ListTileWithSwitchWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final String title, subtitle;
  final bool value;

  @override
  State<ListTileWithSwitchWidget> createState() =>
      _ListTileWithSwitchWidgetState();
}

class _ListTileWithSwitchWidgetState extends State<ListTileWithSwitchWidget> {
  late bool switchValue1; // Declare but don't initialize here

  @override
  void initState() {
    super.initState();
    // Initialize switchValue1 in the initState method
    switchValue1 = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title,
          style: const TextStyle(
              fontSize: Sizes.listTitleFontSize, fontWeight: FontWeight.w500)),
      subtitle: Text(widget.subtitle,
          style: const TextStyle(fontSize: Sizes.listSubtitleFontSize)),
      trailing: Switch(
        value: switchValue1,
        onChanged: (bool? value) {
          setState(() {
            switchValue1 = value!;
          });
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
