import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/common_widgets/bottomnavigationbar.dart';
import 'package:pzdeals/src/common_widgets/custom_scaffold.dart';
import 'package:pzdeals/src/common_widgets/products_display.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class BookmarkedScreenWidget extends ConsumerStatefulWidget {
  const BookmarkedScreenWidget({super.key});
  @override
  BookmarkedScreenWidgetState createState() => BookmarkedScreenWidgetState();
}

class BookmarkedScreenWidgetState extends ConsumerState<BookmarkedScreenWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _scrollController.addListener(_onScroll);

    Future(() {
      ref.read(bookmarkedproductsProvider).resetPageNumber();
      ref.read(bookmarkedproductsProvider).loadProducts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(bookmarkedproductsProvider).loadMoreProducts();
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkedproductsProvider);
    final layoutType = ref.watch(layoutTypeProvider);
    final authUserDataState = ref.watch(authUserDataProvider);

    Widget body;

    if (bookmarkState.isProductLoading && bookmarkState.products.isEmpty) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (bookmarkState.booksmarks.isEmpty &&
        bookmarkState.products.isEmpty) {
      body = Padding(
          padding: const EdgeInsets.all(Sizes.paddingAll),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/lottie/empty.json',
                  height: 200,
                  fit: BoxFit.fitHeight,
                  frameRate: FrameRate.max,
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
                const SizedBox(height: Sizes.spaceBetweenSections),
                const Text(
                  'You have no bookmarked deals yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
                ),
                const SizedBox(height: Sizes.spaceBetweenContentSmall),
                FilledButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const NavigationWidget(
                          initialPageIndex: 0,
                        );
                      }));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(PZColors.pzOrange),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Sizes.buttonBorderRadius,
                          ),
                        ))),
                    child: const Text(
                      'View deals',
                    ))
              ],
            ),
          ));
    } else {
      final productData = bookmarkState.products;
      body = Stack(
        children: [
          Positioned.fill(
              child: ProductsDisplay(
            scrollController: _scrollController,
            productData: productData,
            layoutType: layoutType,
          )),
          if (bookmarkState.isProductLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator.adaptive()),
            ),
        ],
      );
    }

    return authUserDataState.isAuthenticated
        ? CustomScaffoldWidget(
            scaffold: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: GestureDetector(
                  onTap: () {
                    scrollToTop();
                  },
                  child: AppBar(
                    title: const Text(
                      'Bookmarked Deals',
                      style: TextStyle(
                        color: PZColors.pzBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: Sizes.appBarFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    centerTitle: true,
                    surfaceTintColor: PZColors.pzWhite,
                    backgroundColor: PZColors.pzWhite,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              body: body,
              bottomNavigationBar: const BottomNavigationBarWidget(
                currentPageIndex: 4,
              ),
            ),
            scrollAction: scrollToTop)
        : const LoginRequiredScreen(
            message: "Login to unlock amazing ${Wordings.appName} features!",
          );
  }
}
