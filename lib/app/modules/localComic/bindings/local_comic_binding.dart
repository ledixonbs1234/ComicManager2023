import 'package:get/get.dart';

import '../controllers/local_comic_controller.dart';

class LocalComicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalComicController>(
      () => LocalComicController(),
    );
  }
}
