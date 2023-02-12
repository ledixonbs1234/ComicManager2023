import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_source_comic/app/data/model/comicinfo.dart';
import 'package:get_source_comic/app/modules/home/controllers/webcontrol.dart';
import 'package:get_source_comic/app/modules/info/controllers/info_controller.dart';
import 'package:get_source_comic/app/modules/info/views/info_view.dart';
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

class SearchComicController extends GetxController {
  //TODO: Implement SearchComicController
  TextEditingController textEditingController = TextEditingController();
  late WebControl webControl;
  final truyensRx = <ComicInfo>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    webControl = WebControl();
  }

  Future<List<ComicInfo>> getListComic(String word) async {
    String webWord = "https://truyenfull.vn/tim-kiem/?tukhoa=" + word;
    String source = await webControl.getSourceWebAsync(webWord);
    RegExp regTemp = RegExp(r"list list-truyen col(\W|\w)+?pagination");
    String firstRegSource = regTemp.firstMatch(source)!.group(0)!;
    List<ComicInfo> truyens = [];

    RegExp listReg = RegExp(
        r'data-image="((\w|\W)+?)"(\W|\w)+?truyen-title(\w|\W)+?href="((\W|\w)+?)" title="((\w|\W)+?)"(\w|\W)+?author(\w|\W)+?<\/span>((\w|\W)+?)<(\w|\W)+?Chương <\/span><\/span>((\w|\W)+?)<');
    for (var childReg in listReg.allMatches(firstRegSource)) {
      ComicInfo truyen =
          ComicInfo(link: childReg.group(5)!, name: childReg.group(7)!);
      truyen.imagePath = childReg.group(1)!;
      Document a = parse("<div>" + childReg.group(10)! + "</div>");
      truyen.author = childReg.group(11)!;
      truyen.lastChapterLink = childReg.group(14)!;
      truyens.add(truyen);
    }
    return truyens;
  }

  void searchComicWithChar(String text) async {
    List<ComicInfo> truyens = await getListComic(text);
    truyensRx.clear();
    truyensRx.addAll(truyens);
    update();

    String test = "sdfd";
  }

  void gotoInfoScreen(ComicInfo truyen) {
    InfoController controller = Get.find();
    controller.setUpInfo(truyen,false);
    Get.to(const InfoView());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
