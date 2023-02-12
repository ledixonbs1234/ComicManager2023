import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_source_comic/app/modules/info/controllers/info_controller.dart';
import 'package:get_source_comic/app/modules/localComic/controllers/local_comic_controller.dart';
import 'package:get_source_comic/app/modules/searchComic/controllers/search_comic_controller.dart';
import 'package:get_source_comic/app/modules/watch/controllers/watch_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InfoController());
  Get.put(LocalComicController());
  Get.put(SearchComicController());
  Get.put(WatchController());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
