import 'package:get/get.dart';

class WebControl extends GetConnect {
  Future<String> getSourceWebAsync(String url) async {
    Response sourceWeb =
        await get(url);
    if (sourceWeb.isOk) {
      return sourceWeb.bodyString!;
    }
    return "";
  }
}
