import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Sizes.paddingAll),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Layout Settings",
              style: TextStyle(
                  fontSize: Sizes.sectionHeaderFontSize,
                  fontWeight: FontWeight.w600,
                  color: PZColors.pzBlack),
            ),
            SizedBox(height: Sizes.spaceBetweenContentSmall),
            Text(
              "Toggle between grid and list view layout for the deals screen",
              style: TextStyle(fontSize: Sizes.bodyFontSize),
            ),
            SizedBox(height: Sizes.spaceBetweenSectionsXL),
            IconLayout(),
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
                  height: 320,
                )
              : layoutType == 'List'
                  ? Image.asset(
                      'assets/images/layout_list_view.png',
                      height: 320,
                    )
                  : Image.asset(
                      'assets/images/layout_grid_view.png',
                      height: 320,
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
