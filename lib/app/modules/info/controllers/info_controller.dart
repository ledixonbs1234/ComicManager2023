import 'package:flutter/widgets.dart' hide Element;
import 'package:get/get.dart';
import 'package:get_source_comic/app/data/model/comicinfo.dart';
import 'package:get_source_comic/app/data/provider/sqlprovider.dart';
import 'package:get_source_comic/app/modules/home/controllers/webcontrol.dart';
import 'package:get_source_comic/app/modules/watch/controllers/watch_controller.dart';
import 'package:get_source_comic/app/modules/watch/views/watch_view.dart';
import 'package:html/dom.dart';
import 'package:path/path.dart' as p;
import 'package:html/parser.dart';
import 'package:random_string/random_string.dart';

import '../../../data/model/chapterInfo.dart';

class InfoController extends GetxController {
  final count = 0.obs;
  final List<ChapterInfo> chapters = <ChapterInfo>[].obs;
  WebControl webControl = WebControl();
  final truyen = ComicInfo().obs;
  final isEnPre = true.obs;
  final isEnLast = true.obs;
  final isEnNext = true.obs;
  final isEnBack = true.obs;
  final currentChapterReadding = ChapterInfo().obs;
  int pageCurrent = 1;
  bool _isOffline = false;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
  }

  void pageNext() async {
    pageCurrent++;
    runPageCurrent();
  }

//Thực hiện xử pý và hiện page hiện tại
  void runPageCurrent() async {
    chapters.clear();
    if (_isOffline) {
      chapters
          .addAll(await getListChapterFromPage(truyen.value.id!, pageCurrent));
    } else {
      chapters.addAll(await getListChapterComicOnPage(
          "${truyen.value.link}trang-$pageCurrent"));
    }
    update();
  }

  void pagePrevious() async {
    var page = pageCurrent - 1;

    if (page != 0) {
      pageCurrent--;
      runPageCurrent();
    }
  }

  final iCurrentDownloadChapter = 0.obs;
  void downloadComic() async {
    //thuc hien kiem tra thu trong nay co file json
    ComicInfo? comic = await DBProvider.db.getComicFromName(truyen.value.name!);
    comic ??= await DBProvider.db.newComicInfo(truyen.value);

    // List<ChapterInfo> chaptersTemp =
    // await getListChapterComicOnPage(comic!.link!);
    int waiting = 0;
    bool isStop = false;

    while (!isStop) {
      if (waiting < 50) {
        waiting++;

        iCurrentDownloadChapter.value++;
        ChapterInfo chapter = ChapterInfo();
        chapter.comicId = comic!.id;
        chapter.link = "${comic.link!}chuong-$iCurrentDownloadChapter/";
        getChapterFromSimple(chapter).then((chapter) async {
          if (chapter == null) {
            isStop = true;
          }

          waiting--;
        });
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }

      // update();
    }
  }

  int getNumberChapterFromLink(String linkChapter) {
    var path = p.basename(linkChapter);
    RegExp reg = RegExp(r"\d+");
    var math = reg.firstMatch(path);
    if (math != null) {
      String numberText = math.group(0)!;
      return int.parse(numberText);
    }
    return 0;
  }

  Future<ChapterInfo?> getChapterFromSimple(ChapterInfo chapter) async {
    String source = await webControl.getSourceWebAsync(chapter.link!);
    Document documentContent = parse(source);
    chapter.name = await getNameFromDocument(documentContent);
    chapter.ichapter = getNumberChapterFromLink(chapter.link!);
    chapter.content = await getContentChapterFromSource(documentContent);

    if (chapter.content!.isEmpty) {
      return null;
    }
    chapter.isDownload = 1;

    await DBProvider.db.newChapter(chapter);
    return chapter;
  }
  //thuc hien cong viec

  Future<String> getContentChapterFromSource(Document document) async {
    //vao chapter dau tien

    var element = document.getElementById("chapter-c");

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

  void setUpInfo(ComicInfo truyen, bool isOffline) async {
    chapters.clear();
    currentChapterReadding.value = ChapterInfo();
    _isOffline = isOffline;
    pageCurrent = 1;
    if (isOffline) {
      ComicInfo? comic = await DBProvider.db.getComicFromName(truyen.name!);
      if (comic != null) {
        this.truyen.value = comic;
        chapters.addAll(await getListChapterFromPage(comic.id!, pageCurrent));
        if (comic.idChapterReading != null) {
          currentChapterReadding.value =
              (await DBProvider.db.getChapterFromId(comic.idChapterReading!))!;
        }
      }
    } else {
      chapters.addAll(await getListChapterComicOnPage(truyen.link!));
      this.truyen.value = truyen;
    }
    update();
  }

  getListChapterFromPage(int comicId, int page) async {
    List<ChapterInfo> chapters = [];
    for (var i = (page - 1) * 50 + 1; i < page * 50; i++) {
      ChapterInfo? chapter =
          await DBProvider.db.getChapterFromNumberChapter(comicId, i);
      if (chapter != null) {
        chapters.add(chapter);
      }
    }
    return chapters;
  }

  Future<List<ChapterInfo>> getListChapterComicOnPage(String linkComic) async {
    String source = await webControl.getSourceWebAsync(linkComic);

    var document = parse(source);
    // document.getElementById()

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void goToWatchView(ChapterInfo chapter) async {
    var watchV = Get.find<WatchController>();
    if (chapter.isDownload == 1) {
      ChapterInfo? temp = await DBProvider.db.getChapterFromDB(chapter);
      if (temp != null) {
        chapter = temp;
      }
    }
    watchV.onSetUp(chapter.link!);
    Get.to(const WatchView());
  }

  void deleteTable() {
    DBProvider.db.deleteTable();
  }

  Future<String> getNameFromDocument(Document document) async {
    List<Element> element = document.getElementsByClassName("chapter-title");

    if (element.isEmpty) return "";
    String textComic = element.first.text;

    return textComic;
  }
}
