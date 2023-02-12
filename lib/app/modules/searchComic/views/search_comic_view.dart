import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/search_comic_controller.dart';

class SearchComicView extends GetView<SearchComicController> {
  const SearchComicView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchComicView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                onSubmitted: (value) {
                  //thuc hien xu ly trong nay
                  controller.searchComicWithChar(value);
                },
                controller: controller.textEditingController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)))),
          ),
          GetBuilder<SearchComicController>(
              builder: (_dx) => Expanded(
                    child: ListView.builder(
                        itemCount: _dx.truyensRx.length,
                        itemBuilder: (c, p) {
                          return Card(
                            elevation: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(8)),
                                  child: Image.network(
                                    _dx.truyensRx[p].imagePath!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(_dx.truyensRx[p].name!),
                                    subtitle: Text(_dx.truyensRx[p].author!),
                                    trailing: Text(
                                      _dx.truyensRx[p].lastChapterLink!,
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                    onTap: () {
                                      _dx.gotoInfoScreen(_dx.truyensRx[p]);
                                      //thuc hien lenh trong nay
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ))
        ],
      ),
    );
  }
}
