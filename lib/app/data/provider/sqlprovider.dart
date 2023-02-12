import 'dart:io';
import 'package:get_source_comic/app/data/model/chapterInfo.dart';
import 'package:get_source_comic/app/data/model/comicinfo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async => _database ??= await initComicDB();

  initComicDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "DBComic.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (db, int version) async {
      await db.execute("CREATE TABLE Comic ("
          "id INTEGER PRIMARYKEY NOT NULL,"
          "name TEXT,"
          "author TEXT,"
          "link TEXT,"
          "imagePath TEXT,"
          "lastChapterLink TEXT,"
          "idChapterReading INTEGER"
          ")");
      await db.execute("CREATE TABLE Chapter ("
          "id INTEGER PRIMARYKEY NOT NULL,"
          "ichapter INTEGER,"
          "comicId INTEGER NOT NULL,"
          "name TEXT,"
          "content TEXT,"
          "link TEXT,"
          "isDownload INTEGER"
          ")");
    });
  }

  Future<ComicInfo?> getComicFromName(String name) async {
    final db = await database;
    var res = await db.query("Comic", where: "name = ?", whereArgs: [name]);
    ComicInfo? list = res.isNotEmpty ? ComicInfo.fromJson(res.first) : null;
    return list;
  }

  Future<ComicInfo?> getComicFromId(int id) async {
    final db = await database;
    var res = await db.query("Comic", where: "id = ?", whereArgs: [id]);
    ComicInfo? list = res.isNotEmpty ? ComicInfo.fromJson(res.first) : null;
    return list;
  }

  deleteTable() async {
    final db = await database;
    var res = db.delete("Comic");
    var res1 = db.delete("Chapter");
    return res;
  }

  getAllComics() async {
    final db = await database;
    var res = await db.query("Comic");
    List<ComicInfo> list =
        res.isNotEmpty ? res.map((c) => ComicInfo.fromJson(c)).toList() : [];
    return list;
  }

  getAllChapters() async {
    final db = await database;
    var res = await db.query("Chapter");
    List<ChapterInfo> list =
        res.isNotEmpty ? res.map((c) => ChapterInfo.fromJson(c)).toList() : [];
    return list;
  }

  newComicInfo(ComicInfo newComic) async {
    final db = await database;
    List<Map<String, Object?>> table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM Comic");
    if (table.first["id"] != null) {
      int id = table.first["id"] as int;
      newComic.id = id;
    } else {
      newComic.id = 1;
    }
    newComic.lastChapterLink = "";
    var res = await db.insert("Comic", newComic.toJson());
    return newComic;
  }

  // newComicInfo(ComicInfo newcomic) async {
  //   final db = await database;
  //   int id = (await db.rawQuery("select max(id)+1 as id from comic"))
  //           .first["id"] as int ??
  //       1;
  //   await db.insert("comic", newcomic.toMap());
  //   return newcomic;
  // }

  getComicInfo(int id) async {
    final db = await database;
    var res =
        await db.query("Comic", where: "id = ?", whereArgs: [id], limit: 1);
    return res.isNotEmpty ? ComicInfo.fromJson(res.first) : Null;
  }

  updateComicInfo(ComicInfo comic) async {
    final db = await database;
    var res = await db.update("Comic", comic.toJson(),
        where: "id = ?", whereArgs: [comic.id]);
    return res;
  }

  deleteComicInfo(ComicInfo comic) async {
    final db = await database;
    var res = await db.delete("Comic", where: "id = ?", whereArgs: [comic.id]);
    return res;
  }

  newChapter(ChapterInfo chapter) async {
    final db = await database;
    chapter.id = randomBetween(10000, 1000000000);
    var res = await db.insert("Chapter", chapter.toJson());
    return chapter;
  }

  Future<ChapterInfo?> getChapterFromDB(ChapterInfo chapter) async {
    final db = await database;
    var res = await db.rawQuery("select * "
        "from chapter "
        "where comicId = ${chapter.comicId} and link ='${chapter.link}'");
    ChapterInfo? list = res.isNotEmpty ? ChapterInfo.fromJson(res.first) : null;
    return list;
  }

  Future<ChapterInfo?> getChapterFromLink(String link) async {
    final db = await database;
    var res = await db.rawQuery("select * "
        "from chapter "
        "where link ='$link'");
    ChapterInfo? list = res.isNotEmpty ? ChapterInfo.fromJson(res.first) : null;
    return list;
  }

  Future<ChapterInfo?> getChapterFromId(int idChapter) async {
    final db = await database;
    var res = await db.query("Chapter",
        where: "id = ?", whereArgs: [idChapter], limit: 1);
    ChapterInfo? list = res.isNotEmpty ? ChapterInfo.fromJson(res.first) : null;
    return list;
  }

  Future<ChapterInfo?> getChapterFromNumberChapter(int comicId, int i) async {
    final db = await database;
    List<Map<String, Object?>> res = await db.query("Chapter",
        where: "ichapter = ? AND comicId = ?",
        whereArgs: [i, comicId],
        limit: 1);
    ChapterInfo? chapter =
        res.isNotEmpty ? ChapterInfo.fromJson(res.first) : null;
    return chapter;
  }
}
