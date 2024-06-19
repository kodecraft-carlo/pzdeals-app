import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/font_slider.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';
import 'package:pzdeals/src/state/media_query_provider.dart';

class LayoutScreen extends ConsumerStatefulWidget {
  const LayoutScreen({super.key});
  LayoutScreenState createState() => LayoutScreenState();
}

class LayoutScreenState extends ConsumerState<LayoutScreen> {
  late double textScaleFactor =
      ref.read(mediaqueryProvider.select((value) => value.textScaler));
  void textScaleOnchange(double value) {
    setState(() {
      textScaleFactor = value;
    });
    ref.read(mediaqueryProvider).setTextScaler(textScaleFactor);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingAll),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Font Settings",
                  style: TextStyle(
                      fontSize: Sizes.sectionHeaderFontSize,
                      fontWeight: FontWeight.w600,
                      color: PZColors.pzBlack),
                ),
                const SizedBox(height: Sizes.spaceBetweenContentSmall),
                const Text(
                  "Adjust the font slider to increase or decrease the font size",
                  style: TextStyle(fontSize: Sizes.bodyFontSize),
                ),
                const SizedBox(height: Sizes.spaceBetweenContent),
                FontSliderWidget(
                  onChanged: textScaleOnchange,
                  initialValue:
                      textScaleFactor.round() == 0 ? 1 : textScaleFactor,
                ),
              ],
            ),
            const Text(
              "Layout Settings",
              style: TextStyle(
                  fontSize: Sizes.sectionHeaderFontSize,
                  fontWeight: FontWeight.w600,
                  color: PZColors.pzBlack),
            ),
            const SizedBox(height: Sizes.spaceBetweenContentSmall),
            const Text(
              "Toggle between grid and list view layout for the deals screen",
              style: TextStyle(fontSize: Sizes.bodyFontSize),
            ),
            const SizedBox(height: Sizes.spaceBetweenSectionsXL),
            const IconLayout(),
          ],
        ),
      ),
    );
  }
}

class IconLayout extends ConsumerStatefulWidget {
  const IconLayout({super.key});

  @override
  ConsumerState<IconLayout> createState() => _IconLayoutState();
}

class _IconLayoutState extends ConsumerState<IconLayout> {
  @override
  Widget build(BuildContext context) {
    final layoutType = ref.watch(layoutTypeProvider);
    double screenHeight = MediaQuery.of(context).size.height;
    double itemHeight = screenHeight / 2.7;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        ref.read(layoutTypeProvider.notifier).state = 'Grid';
                      }
                    },
                    child: buildIconWithLabel(
                      'Grid',
                      Icons.grid_view_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        ref.read(layoutTypeProvider.notifier).state = 'List';
                      }
                    },
                    child: buildIconWithLabel(
                      'List',
                      Icons.view_stream_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBetweenSectionsXL),
        Center(
          child: layoutType == 'Grid'
              ? Image.asset(
                  'assets/images/layout_grid_view.png',
                  fit: BoxFit.fitHeight,
                  height: itemHeight,
                )
              : layoutType == 'List'
                  ? Image.asset(
                      'assets/images/layout_list_view.png',
                      fit: BoxFit.fitHeight,
                      height: itemHeight,
                    )
                  : Image.asset(
                      'assets/images/layout_grid_view.png',
                      fit: BoxFit.fitHeight,
                      height: itemHeight,
                    ),
        ),
      ],
    );
  }

  Widget buildIconWithLabel(String label, IconData iconData) {
    final layoutType = ref.watch(layoutTypeProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: Sizes.xlargeIconSize,
              color: layoutType == label ? Colors.grey[800] : Colors.grey[600],
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Text(label),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.check_circle,
            color: layoutType == label ? Colors.green : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
