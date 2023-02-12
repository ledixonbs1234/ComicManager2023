import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          controller.deleteTable();
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: Center(
          child: Column(
            children: [
              Row(
                children: const [
                  BackButton(),
                ],
              ),
              Obx(
                () => Column(
                  children: [
                    Text(controller.iCurrentDownloadChapter.value.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                            child: Image.network(
                          controller.truyen.value.imagePath!,
                          fit: BoxFit.fill,
                          width: 100,
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.truyen.value.name ??= "",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 17,
                                  )),
                              Text(
                                  "Chương mới nhất :${controller.truyen.value.lastChapterLink}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.blueGrey)),
                              IconButton(
                                  onPressed: () => controller.downloadComic(),
                                  icon: Icon(Icons.download)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => controller.currentChapterReadding.value.name != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: Get.width,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 8),
                                    child: Text("Chương đang đọc",
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    controller.goToWatchView(controller
                                        .currentChapterReadding.value);
                                  },
                                  child: Text(controller
                                      .currentChapterReadding.value.name!))
                            ],
                          ),
                        ),
                      )
                    : Text(""),
              ),
              GetBuilder<InfoController>(
                builder: (_dx) => Expanded(
                  child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: _dx.chapters.length,
                      itemBuilder: (c, p) {
                        return Card(
                          child: ListTile(
                              onTap: () {
                                controller.goToWatchView(_dx.chapters[p]);
                              },
                              title: Text(_dx.chapters[p].name ??= ""),
                              textColor: Colors.black87,
                              trailing: _dx.chapters[p].isDownload == 1
                                  ? const Icon(Icons.check)
                                  : null),
                        );
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.skip_previous_rounded),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.isEnPre.value
                                  ? Colors.green
                                  : Colors.blueGrey.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(5)),
                          ))),
                      label: Text(""),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.pagePrevious();
                      },
                      icon: Icon(Icons.navigate_before),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.isEnNext.value
                                  ? Colors.green
                                  : Colors.blueGrey.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(1)),
                          ))),
                      label: const Text(""),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.pageNext();
                      },
                      icon: Icon(Icons.navigate_next),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.isEnPre.value
                                  ? Colors.green
                                  : Colors.blueGrey.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(1)),
                          ))),
                      label: Text(""),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.skip_next),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              controller.isEnPre.value
                                  ? Colors.green
                                  : Colors.blueGrey.shade200),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(5)),
                          ))),
                      label: Text(""),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
