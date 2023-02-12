import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_source_comic/app/modules/info/controllers/info_controller.dart';
import 'package:get_source_comic/app/modules/info/views/info_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/watch_controller.dart';

class WatchView extends GetView<WatchController> {
  const WatchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: const [BackButton()],
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(controller.comicName.value.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 23,
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      controller.chapterCurrentName.value,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.blueGrey),
                    ),
                  ),
                  navigationChuong(),
                  const SizedBox(
                    height: 15,
                  ),
                  EasyRichText(
                    controller.content.value,
                    defaultStyle: const TextStyle(
                        height: 1.8,
                        fontFamily: "Arial",
                        color: Color(0xFF2B2B2B),
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                    patternList: [
                      EasyRichTextPattern(
                        targetString: r'“(\w|\W)+?”',
                        style: const TextStyle(
                            color: Colors.black87, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  navigationChuong(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row navigationChuong() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
              onPressed: controller.isEnPreviousButton.value
                  ? () => controller.previousChapter()
                  : null,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
                size: 40,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      controller.isEnPreviousButton.value
                          ? Colors.green
                          : Colors.blueGrey.shade200),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5)),
                  ))),
              label: const Text("Trước")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                onPressed: controller.isEnNextButton.value
                    ? () => controller.nextChapter()
                    : null,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 40,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        controller.isEnNextButton.value
                            ? Colors.green
                            : Colors.blueGrey.shade200),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(5)),
                    ))),
                label: const Text("Sau")),
          ),
        )
      ],
    );
  }
}
