import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/HttpServices.dart';
import '../model/AddCollectModel.dart';

// ignore: must_be_immutable
class WebViewPageUI extends StatefulWidget {
  String url;
  String title;
  String author;
  bool isCollect;
  int _id;

  WebViewPageUI(
      {Key key,
      @required this.url,
      @required this.title,
      this.author,
      this.isCollect})
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
                    color: Theme.of(context).primaryColor,
                  ),
            preferredSize: const Size.fromHeight(1.0)),
        actions: _appBarAction(),
      ),
      body: new WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          setState(() {
            isLoad = false;
          });
        },
      ),
    );
  }

  List<Widget> _appBarAction() {
    return [
      new IconButton(
          icon: widget.isCollect
              ? new Icon(Icons.favorite)
              : new Icon(Icons.favorite_border),
          onPressed: _handlerPress)
    ];
  }

  void _handlerPress() {
    if (widget.isCollect) {
      _removeCollect();
    } else {
      _addCollect();
    }
  }

  Future<Null> _addCollect() async {
    CommonService().addArticleCollection(
        (AddCollectModel _model, Response _response) {
      setState(() {
        if (_model.errorCode == 0) {
          widget.isCollect = true;
          widget._id = _model.data.id;
          Fluttertoast.showToast(msg: "收藏成功");
        } else {
          widget.isCollect = false;
          Fluttertoast.showToast(msg: "请稍后再试");
        }
      });
    }, widget.title, widget.author, widget.url);
  }

  Future<Null> _removeCollect() async {
    CommonService().removeArticleCollection((AddCollectModel _model) {
      setState(() {
        if (_model.errorCode == 0) {
          widget.isCollect = false;
          Fluttertoast.showToast(msg: "取消收藏");
        }
      });
    }, widget._id);
  }
}
