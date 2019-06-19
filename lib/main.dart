import 'package:flutter/material.dart';
import './widget/MyBottomNavigation.dart';
import './ui/DrawWidgetUI.dart';
import './ui/SearchPageUI.dart';
import './ui/HomePageUI.dart';
import './ui/SystemTressUI.dart';
import './ui/WxArticleListPageUI.dart';
import 'utils/RouteUtil.dart';

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

  bool _isShowAppBar = true;
  bool _isShowDraw = true;


  @override
  void initState() {
    super.initState();
    _pageList = [
      HomePageUI(),
      SystemTreeUI(),
      WxArticleListPageUI(),
    ];
  }

  void _handleChange(int value){
    _index = value;
    setState(() {
      if(value == 0 || value == 1 || value == 3) {
        _isShowAppBar = true;
      } else{
        _isShowAppBar = false;
      }

      if(value == 0) {
        _isShowDraw = true;
      } else {
        _isShowDraw = false;
      }
    });
  }


  Widget _appBarWidget(BuildContext context) {
    return new AppBar(
        title: Text(_titleList[_index]),
        elevation: 4.0,
        actions: _appBarAction()
    );
  }
  
  void _handlerPress() {
    RouteUtils.push(context, new WidgetSearchPage(null));
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
    return new WillPopScope(
        child: new DefaultTabController(
            length: 5,
            child: new Scaffold(
              appBar: _isShowAppBar ? _appBarWidget(context) : null,
              drawer: _isShowDraw ? WidgetDraw() : null,
              bottomNavigationBar: MyBottomNavigation(
                  onChange: _handleChange,
              index: _index,),
              body: new IndexedStack(
                index: _index,
                children: _pageList,
              ),
        )),
        onWillPop: null
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
