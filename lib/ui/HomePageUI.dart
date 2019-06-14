import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/ArticleModel.dart';
import 'DrawWidgetUI.dart';
import '../widget/BannerWidger.dart';
import '../api/HttpServices.dart';
import '../utils/timeline_util.dart';
import '../utils/RouteUtil.dart';

class HomePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePageUI>
    with AutomaticKeepAliveClientMixin {
  List<Article> _data = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0; //加载的页数

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        getMoreData();
      }
    });
  }

  Future<Null> getData() async {
    _page = 0;
    print("$_page");

    CommonService().getArticleList((ArticleModel _articleModel) {
      setState(() {
        _data = _articleModel.data.datas;
      });
    }, _page);
  }

  Future<Null> getMoreData() async {
    _page++;
    print("$_page");

    CommonService().getArticleList((ArticleModel _articleModel) {
      setState(() {
        _data.addAll(_articleModel.data.datas);
      });
    }, _page);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(
          child: new ListView.separated(
            itemBuilder: _rendRow,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.black26,
              );
            },
            itemCount: _data.length + 2,
            controller: _scrollController,
          ),
          onRefresh: getData),
      drawer: WidgetDraw(),
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        height: 200,
        color: Colors.grey,
        child: new BannerWidget(),
      );
    }

    if (index - 1 < _data.length) {
      return InkWell(
        onTap: () {
          RouteUtils.toWebView(context, _data[index-1].title, _data[index-1].link);
        },
        child: new Column(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: new Row(
                children: <Widget>[
                  new Text(
                    _data[index - 1].author,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  new Expanded(
                    child: new Text(
                      TimelineUtil.format(_data[index - 1].publishTime),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      _data[index - 1].title,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8, right: 16),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      _data[index - 1].superChapterName,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return _getMoreWidget();
  }

  ///上拉加载状态
  Widget _getMoreWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
