import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewPageUI extends StatefulWidget {
  String url;
  String title;

  WebViewPageUI({Key key, @required this.url, @required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPageUI> {
  bool isLoad = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.4,
        title: new Text(widget.title),
        bottom: new PreferredSize(
            child: isLoad
                ? new LinearProgressIndicator()
                : new Divider(
              height: 1.0,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            preferredSize: const Size.fromHeight(1.0)),
      ),
      body: new WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url){
          setState(() {
            isLoad = false;
          });
        },
      ),
    );
  }
}
