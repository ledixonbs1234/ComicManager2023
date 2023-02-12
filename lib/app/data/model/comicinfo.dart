import 'dart:convert';

import 'package:get_source_comic/app/data/model/chapterInfo.dart';

ComicInfo comicInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return ComicInfo.fromJson(jsonData);
}

String ComicInfoToJson(ComicInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ComicInfo {
  int? id;
  String? name;
  String? author;
  String? link;
  String? imagePath;
  String? lastChapterLink;
  int? idChapterReading;
  ChapterInfo? chapterReading;

  ComicInfo(
      {this.id,
      this.name,
      this.author,
      this.link,
      this.imagePath,
      this.lastChapterLink,
      this.idChapterReading,
      this.chapterReading});

  ComicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    author = json['author'];
    link = json['link'];
    imagePath = json['imagePath'];
    lastChapterLink = json['lastChapterLink'];
    idChapterReading = json['idChapterReading'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['author'] = author;
    data['link'] = link;
    data['imagePath'] = imagePath;
    data['lastChapterLink'] = lastChapterLink;
    data['idChapterReading'] = idChapterReading;
    return data;
  }
}
