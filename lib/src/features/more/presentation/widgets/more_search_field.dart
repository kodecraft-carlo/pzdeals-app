import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_deals.dart';

class MoreScreenSearchFieldWidget extends StatelessWidget {
  const MoreScreenSearchFieldWidget({super.key, required this.hintText});

  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: PZColors.pzOrange,
            size: Sizes.textFieldIconSize,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
          hintText: hintText,
          fillColor: PZColors.pzGrey.withOpacity(0.125),
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall)),
      style: const TextStyle(
          fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
      onTap: () => {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SearchDealScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const curve = Curves.easeInOut;
              var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: curve));
              var fadeAnimation = animation.drive(opacityTween);
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
          ),
        )
      },
    );
  }
}
