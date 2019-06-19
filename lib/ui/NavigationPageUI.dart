import 'package:flutter/material.dart';
import '../model/NavigationModel.dart';
import '../api/HttpServices.dart';
import '../utils/RouteUtil.dart';

class NavigationPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NavigationState();
  }

}

class _NavigationState extends State<NavigationPageUI> {
  List<NavigationData> _data = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    CommonService().getNavigationList((NavigationModel _model) {
      setState(() {
        _data = _model.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: _contentList(context),
      ),
    );
  }

  Widget _contentList(BuildContext context) {
    return ListView.builder(
      itemBuilder: _rendRow,
      itemCount: _data.length,
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    if (index < _data.length) {
      return _rendContent(index);
    }
    return null;
  }

  Widget _rendContent(int index) {
    return new Container(
      padding: EdgeInsets.all(16),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              _data[index].name,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            child: _buildContent(_data[index].articles),
          )
        ],
      ),
    );
  }

  Widget _buildContent(List<NavigationArticle> children) {
    List<Widget> widgets = new List();
    Widget content;
    for (var value in children) {
      widgets.add(hotKey(value));
    }

    content = new Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: widgets,
    );

    return content;
  }

  Widget hotKey(NavigationArticle article) {
    return new InkWell(
      child: new Chip(label: new Text(article.title)),
      onTap: () {
        _onItemClick(article);
      },
    );
  }

  void _onItemClick(NavigationArticle article) {
    RouteUtils.toWebView(context, article.title, article.link);
  }

}