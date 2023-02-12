import 'package:get/get.dart';
import 'package:get_source_comic/app/data/provider/sqlprovider.dart';

import '../../../data/model/comicinfo.dart';
import '../../info/controllers/info_controller.dart';
import '../../info/views/info_view.dart';
import '../../watch/controllers/watch_controller.dart';
import '../../watch/views/watch_view.dart';

class LocalComicController extends GetxController {
  final comics = <ComicInfo>[].obs;

  final count = 0.obs;

  Future<List<ComicInfo>> getComicsDownload() async {
    List<ComicInfo> truyens = await DBProvider.db.getAllComics();
    for (var truyen in truyens) {
      if (truyen.idChapterReading != null) {
        truyen.chapterReading =
            await DBProvider.db.getChapterFromId(truyen.idChapterReading!);
      }
    }
    return truyens;
  }

  void goToWatchView(ComicInfo comic) async {
    if (comic.lastChapterLink!.isNotEmpty) {
      var watchV = Get.find<WatchController>();
      watchV.onSetUp(comic.lastChapterLink!);
      Get.to(const WatchView());
    } else {
      gotoInfoScreen(comic);
    }
  }

  void gotoInfoScreen(ComicInfo truyen) {
    InfoController controller = Get.find();
    controller.setUpInfo(truyen, true);
    Get.to(const InfoView());
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    comics.value = await getComicsDownload();
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
