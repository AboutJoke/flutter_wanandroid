import 'package:flutter/material.dart';
import '../ui/WebViewPageUI.dart';

class RouteUtils {
  static toWebView(
      {@required BuildContext context,
      @required String title,
      @required String url,
      String author,
      bool isCollect}) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: title,
        url: url,
        author: author,
        isCollect: isCollect,
      );
    }));
  }

  static Future push(BuildContext context, Widget widget) {
    Future result = Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    return result;
  }
}
