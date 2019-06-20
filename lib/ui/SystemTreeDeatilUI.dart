import 'package:flutter/material.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../api/HttpServices.dart';
import '../utils/RouteUtil.dart';
import '../utils/timeline_util.dart';
import '../widget/CommonListView.dart';

class SystemTreeDetail extends StatefulWidget {
  SystemTreeData data;

  SystemTreeDetail(ValueKey<SystemTreeData> key) : super(key: key) {
    this.data = key.value;
  }

  @override
  State<StatefulWidget> createState() {
    return new _SystemTreeState();
  }
}

class _SystemTreeState extends State<SystemTreeDetail>
    with TickerProviderStateMixin {
  SystemTreeData data;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController =
        new TabController(length: data.children.length, vsync: this);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(data.name),
        elevation: 0.4,
        bottom: new TabBar(
          controller: _tabController,
          tabs: data.children.map((SystemTreeChild item) {
            return Tab(
              text: item.name,
            );
          }).toList(),
          isScrollable:
              true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: data.children.map((item) {
          return DetailList(
            id: item.id,
          );
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
  List<SystemTreeContentChild> _data = new List();
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
    CommonService().getSystemTreeContent((SystemTreeContentModel _model) {
      setState(() {
        pageCount = _model.data.pageCount;
        _data = _model.data.datas;
        if (_model.data.pageCount == 1) {
          hasMoreData = false;
        } else {
          hasMoreData = true;
        }
      });
    }, page, widget.id);
  }

  Future<Null> _getMoreData() async {
    page++;
    if (page < pageCount) {
      CommonService().getSystemTreeContent((SystemTreeContentModel _model) {
        setState(() {
          isLastPage = false;
          _data.addAll(_model.data.datas);
        });
      }, page, widget.id);
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
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: _renderRow,
          itemCount: _data.length + 1,
          controller: _scrollController,
          separatorBuilder: _separatorView,
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
        RouteUtils.toWebView(
            context: context,
            title: _data[index].title,
            url: _data[index].link,
            author: _data[index].author,
            isCollect: _data[index].collect);
      },
    );
  }

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

  Widget _newsRow(SystemTreeContentChild item) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                new Expanded(
                  child: new Text(
                    TimelineUtil.format(item.publishTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ))
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Text(
                  item.superChapterName,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                new Text(
                  "/" + item.chapterName,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ],
            )),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
