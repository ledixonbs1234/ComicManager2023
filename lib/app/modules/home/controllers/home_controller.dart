import 'dart:async';

import 'package:get/get.dart';
import 'package:get_source_comic/app/data/model/chapterInfo.dart';
import 'package:get_source_comic/app/data/provider/sqlprovider.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import '../../../data/model/comicinfo.dart';
import 'webcontrol.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  WebControl webControl = WebControl();
  final count = 0.obs;
  final contentChapter = "".obs;
  final selectedIndex = 0.obs;
  final List<ChapterInfo> chapters = <ChapterInfo>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  ///Lấy danh sách truyện
  Future<List<ComicInfo>> getListComic() async {
    //thuc hien lay danh sach trong nay
    //get source list
    var text = await webControl
        .getSourceWebAsync('https://truyenfull.vn/danh-sach/truyen-hot/');
    if (text == "") {
      Get.snackbar("Thông báo", "Không có dữ liệu comic");
      return [];
    }

    //thuc hien regex no
    var tempRegex = RegExp(r'col-truyen-main"((\W|\w)+)pagination-container');
    var textRegex = tempRegex.firstMatch(text)!.group(1);
    List<ComicInfo> truyens = [];

    var resultRegex =
        RegExp(r'truyen-title(\w|\W)+?href="((\w|\W)+?)" title="((\W|\w)+?)"');
    for (var results in resultRegex.allMatches(textRegex!)) {
      var link = results.group(2);
      var name = results.group(4);
      truyens.add(ComicInfo());
    }
    return truyens;
  }

  ///Lấy danh sách chapter
  Future<List<ChapterInfo>> getListChapterComicOnPage(String linkComic) async {
    String source = await webControl.getSourceWebAsync(linkComic);

    var tempRegex = RegExp(r'title-list"((\W|\w)+)pagination');
    var textRegex = tempRegex.firstMatch(source)!.group(1);
    List<ChapterInfo> chapters = [];

    var resultRegex = RegExp(
        r'<a href="((\w|\W)+?)" title="(\w|\W)+?"><span class="chapter-text"><span>Chương <\/span><\/span>((\w|\W)+?)<\/a>');
    for (var results in resultRegex.allMatches(textRegex!)) {
      var link = results.group(1);
      var nameChapter = results.group(4);
      chapters.add(ChapterInfo(name: nameChapter!, link: link!));
    }
    return chapters;
  }

  void excutePageComic() async {
    List<ComicInfo> truyens = await getListComic();
    List<ChapterInfo> listChapter =
        await getListChapterComicOnPage(truyens[0].link!);
    chapters.addAll(listChapter);
    update();

    for (var chapterTemp in chapters) {
      var chapterCurent = chapters
          .firstWhereOrNull((element) => element.name == chapterTemp.name);
      if (chapterCurent!.isDownload == 0) {
        getContentChapter(chapterTemp.link!).then((value) {
          chapterCurent.content = value;
          chapterCurent.isDownload = 1;
          update();
        });
      }

      // chapters.refresh();
    }
  }

  ///Lay noi trung cua chapter
  Future<String> getContentChapter(String linkChapter) async {
    //vao chapter dau tien
    String source = await webControl.getSourceWebAsync(linkChapter);

    Document documentContent = parse(source);
    Element? element = documentContent.getElementById("chapter-c");
    if (element == null) return "";
    NodeList textComic = element.nodes;
    String text = "";
    for (var element in textComic) {
      // if(element.nodeType == )
      if (element.text != "") {
        text += "${element.text!}\n";
      }
    }
    return text;
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

  void deleteDatabase() {
    DBProvider.db.deleteTable();
  }
}
