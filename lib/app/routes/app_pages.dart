import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/info/bindings/info_binding.dart';
import '../modules/info/views/info_view.dart';
import '../modules/localComic/bindings/local_comic_binding.dart';
import '../modules/localComic/views/local_comic_view.dart';
import '../modules/searchComic/bindings/search_comic_binding.dart';
import '../modules/searchComic/views/search_comic_view.dart';
import '../modules/watch/bindings/watch_binding.dart';
import '../modules/watch/views/watch_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_COMIC,
      page: () => const SearchComicView(),
      binding: SearchComicBinding(),
    ),
    GetPage(
      name: _Paths.LOCAL_COMIC,
      page: () => const LocalComicView(),
      binding: LocalComicBinding(),
    ),
    GetPage(
      name: _Paths.INFO,
      page: () => const InfoView(),
      binding: InfoBinding(),
    ),
    GetPage(
      name: _Paths.WATCH,
      page: () => const WatchView(),
      binding: WatchBinding(),
    ),
  ];
}
