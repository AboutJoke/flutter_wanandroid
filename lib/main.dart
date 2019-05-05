import 'package:flutter/material.dart';
import './widget/MyBottomNavigation.dart';
import './ui/DrawWidgetUI.dart';
import './ui/SearchPageUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WanAdndroid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _MyHomeState();
  }
}



class _MyHomeState extends State<MyHomePage> with AutomaticKeepAliveClientMixin{
  int _index = 0;
  var _pageList;
  var _titleList = [
    "首页",
    "知识体系",
    "公众号",
    "导航",
    "项目",
  ];

  bool _isShowDraw = true;

  void _handleChange(int value){

  }


  Widget _appBarWidget(BuildContext context) {
    return new AppBar(
        title: Text(_titleList[_index]),
        elevation: 4.0,
        actions: _appBarAction()
    );
  }
  
  void _handlerPress() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return new WidgetSearchPage(null);
    }));
  }

  List<Widget> _appBarAction() {
    if (_isShowDraw) {
      return [
        new IconButton(
            icon: new Icon(Icons.search),
            onPressed: _handlerPress)
      ];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Scaffold(
        appBar: _appBarWidget(context),
        drawer: WidgetDraw(),
        bottomNavigationBar: MyBottomNavigation(
          index: _index,
          onChange: _handleChange,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
