import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/blogs_search_field.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/card_blogpost.dart';
import 'package:pzdeals/src/features/more/state/blogs_provider.dart';
import 'package:pzdeals/src/utils/helpers/debouncer.dart';

final blogsProvider =
    ChangeNotifierProvider<BlogsNotifier>((ref) => BlogsNotifier());

class BlogScreenWidget extends ConsumerStatefulWidget {
  const BlogScreenWidget({super.key});

  BlogScreenWidgetState createState() => BlogScreenWidgetState();
}

class BlogScreenWidgetState extends ConsumerState<BlogScreenWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  final _scrollController = ScrollController(keepScrollOffset: true);
  final GlobalKey<NestedScrollViewState> globalKey =
      GlobalKey<NestedScrollViewState>();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  late TextEditingController searchController;

  void _onTextChanged(String text) {
    _debouncer.run(() {
      filterBlogs(text);
    });
  }

  void filterBlogs(String query) {
    ref.read(blogsProvider).filterBlogs(query);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    Future(() => ref.read(blogsProvider).loadBlogs());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isLoading) {
        return;
      }

      _isLoading = true;
      await ref.read(blogsProvider).loadMoreBlogs();
      _isLoading = false;
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
    final blogState = ref.watch(blogsProvider);
    Widget body;
    if (blogState.isLoading && blogState.blogs.isEmpty) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (blogState.blogs.isEmpty) {
      body = Padding(
          padding: const EdgeInsets.all(Sizes.paddingAll),
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
                'There\'s no blog available at the moment. Please check back later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
              ),
            ],
          ));
    } else {
      final blogData = blogState.filteredBlogs.isNotEmpty
          ? blogState.filteredBlogs
          : blogState.blogs;
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator.adaptive(
                  color: PZColors.pzOrange,
                  child: ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: blogData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final blog = blogData[index];
                      return BlogpostCardWidget(
                        blogTitle: blog.blogTitle,
                        blogImage: blog.blogImage,
                        blogId: blog.id,
                      );
                    },
                  ),
                  onRefresh: () => blogState.refreshBlogs()),
            ),
            if (blogState.isLoading && blogState.blogs.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.paddingAll),
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        ),
      );
    }
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        key: globalKey,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              title: const Text(
                'Blog',
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
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
                child: BlogSearchFieldWidget(
                    hintText: 'Search blog',
                    searchController: searchController,
                    filterData: _onTextChanged),
              ),
            ),
          ];
        },
        body: body,
      ),
    );
  }
}
