import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_source_comic/app/data/model/chapterInfo.dart';
import 'package:get_source_comic/app/data/model/comicinfo.dart';
import 'package:get_source_comic/app/data/provider/sqlprovider.dart';
import 'package:get_source_comic/app/modules/home/controllers/webcontrol.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as p;

import '../../info/controllers/info_controller.dart';
import '../../info/views/info_view.dart';

class WatchController extends GetxController {
  final content = "".obs;
  WebControl webControl = WebControl();
  ScrollController scrollController = ScrollController();

  String preChapterLink = "";
  String nextChapterLink = "";
  final comicName = "".obs;
  final chapterCurrentName = "".obs;
  int chapterNumber = 0;
  bool _isOffline = false;

  final isEnPreviousButton = true.obs;
  final isEnNextButton = true.obs;
  late ComicInfo comicCurent;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void onSetUp(String linkChapter) async {
    executeChapter(linkChapter);
  }

  executeChapter(String link) async {
    var path = p.basename(link);
    RegExp reg = RegExp(r"\d+");
    var math = reg.firstMatch(path);
    if (math != null) {
      String numberText = math.group(0)!;
      chapterNumber = int.parse(numberText);
    }
    //check chapter exist on database
    ChapterInfo? chapter = await DBProvider.db.getChapterFromLink(link);

    if (chapter != null) {
      ComicInfo? comic = await DBProvider.db.getComicFromId(chapter.comicId!);
      if (comic != null) {
        _isOffline = true;
        comicCurent = comic;
        comic.idChapterReading = chapter.id;
        DBProvider.db.updateComicInfo(comic);
      } else {
        _isOffline = false;
      }
      comicName.value = comic!.name!;

      chapterCurrentName.value = chapter.name!;
      content.value = chapter.content!;
      preChapterLink = "${p.dirname(link)}/chuong-${chapterNumber - 1}";
      nextChapterLink = "${p.dirname(link)}/chuong-${chapterNumber + 1}";
    } else {
      String sourceWeb = await webControl.getSourceWebAsync(link);
      content.value = await getContentChapterFromSource(sourceWeb);
      excuteChapterFromSource(sourceWeb);
    }
  }

  backCommand() {
    Get.back();
    // var info = Get.find<InfoController>();
    // info.setUpInfo(comicCurent, _isOffline);
    // Get.to(InfoView());
  }

  Future<String> getContentChapterFromSource(String sourceWeb) async {
    //vao chapter dau tien
    Document documentContent = parse(sourceWeb);
    var element = documentContent.getElementById("chapter-c");

    if (element == null) return "";
    NodeList textComic = element.nodes;
    String text = "\t";
    for (var element in textComic) {
      // if(element.nodeType == )
      if (element.text != "") {
        if (element.nodes.isNotEmpty) {
          for (var child in element.nodes) {
            if (child.text != "") text += "${child.text!}\n\n\t";
          }
        } else {
          text += "${element.text!}\n\n\t";
        }
      }
    }
    return text;
  }

  void excuteChapterFromSource(String sourceWeb) async {
    isEnNextButton.value = true;
    isEnPreviousButton.value = true;

    Document documentContent = parse(sourceWeb);

    comicName.value = documentContent
        .getElementsByClassName("truyen-title")
        .first
        .attributes["title"]!;
    chapterCurrentName.value =
        documentContent.getElementsByClassName("chapter-title").first.text;

    preChapterLink =
        documentContent.getElementById("prev_chap")!.attributes["href"]!;
    nextChapterLink =
        documentContent.getElementById("next_chap")!.attributes['href']!;

    if (preChapterLink.contains("javascript")) {
      isEnPreviousButton.value = false;
    }
    if (nextChapterLink.contains("javascript")) {
      isEnNextButton.value = true;
    }
  }

  void nextChapter() async {
    executeChapter(nextChapterLink);
    scrollController.jumpTo(0);
  }

  void previousChapter() async {
    executeChapter(preChapterLink);

    scrollController.jumpTo(0);
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
