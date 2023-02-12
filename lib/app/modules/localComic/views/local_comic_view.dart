import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/local_comic_controller.dart';

class LocalComicView extends GetView<LocalComicController> {
  const LocalComicView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalComicView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<LocalComicController>(
                builder: (_dx) => Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          controller.onReady();
                          return Future<void>.delayed(
                              const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                            itemCount: _dx.comics.length,
                            itemBuilder: (c, p) {
                              return Card(
                                elevation: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              left: Radius.circular(8)),
                                      child: Image.network(
                                        _dx.comics[p].imagePath!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(_dx.comics[p].name!),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_dx.comics[p].author!),
                                            _dx.comics[p].chapterReading != null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      _dx
                                                          .comics[p]
                                                          .chapterReading!
                                                          .name!,
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .orangeAccent),
                                                    ),
                                                  )
                                                : const Text(""),
                                          ],
                                        ),

                                        // trailing: Text(
                                        //   _dx.comics[p].lastChapterLink!,
                                        //   style: const TextStyle(
                                        //       color: Colors.deepOrange),
                                        // ),
                                        onTap: () {
                                          _dx.goToWatchView(_dx.comics[p]);
                                          //thuc hien lenh trong nay
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
