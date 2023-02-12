import 'package:get/get.dart';

import '../controllers/search_comic_controller.dart';

class SearchComicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchComicController>(
      () => SearchComicController(),
    );
  }
}
