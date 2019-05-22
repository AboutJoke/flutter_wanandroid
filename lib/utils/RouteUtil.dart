import 'package:flutter/material.dart';
import '../ui/WebViewPageUI.dart';

class RouteUtils {
  static toWebView(BuildContext context, String title, String url) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: title,
        url: url,
      );
    }));
  }

  static Future push(BuildContext context, Widget widget) {
    Future result = Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    return result;
  }
}
