import 'package:flutter/material.dart';
import '../model/WxArticleTitleModel.dart';
import '../api/HttpServices.dart';
import '../model/WxArticleContentModel.dart';
import '../utils/RouteUtil.dart';
import '../widget/CommonListView.dart';
import '../utils/timeline_util.dart';

class WxArticleListPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WxArticleListState();
  }
}

class _WxArticleListState extends State<WxArticleListPageUI>
    with TickerProviderStateMixin {
  List<WxArticleTitleData> data = new List();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<Null> _getData() async {
    CommonService().getWxTitleList((WxArticleTitleModel _model) {
      setState(() {
        data = _model.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(length: data.length, vsync: this);

    return new Scaffold(
      appBar: new AppBar(
        title: new TabBar(
          controller: _tabController,
          tabs: data.map(
            (WxArticleTitleData item) {
              return Tab(
                text: item.name,
              );
            },
          ).toList(),
          isScrollable: true,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: data.map((WxArticleTitleData item) {
          return new DetailList(id: item.id);
        }).toList(),
      ),
    );
  }
}

class DetailList extends StatefulWidget {
  int id;

  DetailList({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DetailListState();
  }
}

class _DetailListState extends State<DetailList> {
  List<WxArticleContentDatas> _data = new List();
  ScrollController _scrollController = new ScrollController();
  int page = 0;
  int pageCount = 0;
  bool isLastPage = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMoreData) {
        _getMoreData();
      }
    });
  }

  Future<Null> _getData() async {
    page = 0;
    CommonService().getWxArticleList((WxArticleContentModel _model) {
      setState(() {
        pageCount = _model.data.pageCount;
        _data = _model.data.datas;
        if (_model.data.pageCount == 1) {
          hasMoreData = false;
        } else {
          hasMoreData = true;
        }
      });
    }, widget.id, page);
  }

  Future<Null> _getMoreData() async {
    page++;
    if (page < pageCount) {
      CommonService().getWxArticleList((WxArticleContentModel _model) {
        setState(() {
          isLastPage = false;
          _data.addAll(_model.data.datas);
        });
      }, widget.id, page);
    } else {
      setState(() {
        isLastPage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: _renderRow,
          itemCount: _data.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return _itemView(context, index);
    } else if (!isLastPage && hasMoreData) {
      return CommonListView.loading();
    } else {
      return CommonListView.noData();
    }
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      child: _newsRow(_data[index]),
      onTap: () {
        RouteUtils.toWebView(context, _data[index].title, _data[index].link);
      },
    );
  }

  Widget _newsRow(WxArticleContentDatas item) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    item.title,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ))
                ],
              )),
          new Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      TimelineUtil.format(item.publishTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
//    return new Column(
//      children: <Widget>[
//        new Container(
//            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
//            child: new Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text(
//                  item.author,
//                  style: TextStyle(fontSize: 12, color: Colors.grey),
//                ),
//                new Expanded(
//                  child: new Text(
//                    TimelineUtil.format(item.publishTime),
//                    style: TextStyle(fontSize: 12, color: Colors.grey),
//                    textAlign: TextAlign.right,
//                  ),
//                ),
//              ],
//            )),
//        Container(
//            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                    child: Text(
//                  item.title,
//                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                  textAlign: TextAlign.left,
//                ))
//              ],
//            )),
//        Container(
//            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  item.superChapterName,
//                  style: TextStyle(fontSize: 12, color: Colors.grey),
//                ),
//                new Text(
//                  "/" + item.chapterName,
//                  style: TextStyle(fontSize: 12, color: Colors.grey),
//                  textAlign: TextAlign.right,
//                ),
//              ],
//            )),
//      ],
//    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
