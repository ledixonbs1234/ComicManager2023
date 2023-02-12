class ChapterInfo {
  int id = 0;
  int? comicId;
  String? name;
  String? link;
  String? content;
  int? ichapter;
  int? isDownload;

  ChapterInfo(
      {this.id = 0,
      this.comicId,
      this.name,
      this.link,
      this.content,
      this.ichapter,
      this.isDownload});

  ChapterInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comicId = json['comicId'];
    name = json['name'];
    link = json['link'];
    content = json['content'];
    ichapter = json['ichapter'];
    isDownload = json['isDownload'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['comicId'] = comicId;
    data['name'] = name;
    data['link'] = link;
    data['content'] = content;
    data['ichapter'] = ichapter;
    data['isDownload'] = isDownload;
    return data;
  }
}
