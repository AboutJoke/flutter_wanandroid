import 'package:flutter/material.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../api/HttpServices.dart';
import '../utils/RouteUtil.dart';
import '../utils/timeline_util.dart';

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
  bool isLastData = false;

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  Future<Null> _getData() async {
    page = 0;
    CommonService().getSystemTreeContent((SystemTreeContentModel _model) {
      setState(() {
        pageCount = _model.data.pageCount;
        print(_model.data.pageCount);
        _data = _model.data.datas;
      });
    }, page, widget.id);
  }

  Future<Null> _getMoreData() async {
    page++;
    if (page < pageCount) {
      CommonService().getSystemTreeContent((SystemTreeContentModel _model) {
        setState(() {
          isLastData = false;
          _data.addAll(_model.data.datas);
        });
      }, page, widget.id);
    } else {
      setState(() {
        isLastData = true;
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
    } else if (!isLastData) {
      return _getMoreWidget();
    } else {
      return _lastWidget();
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

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

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

  Widget _lastWidget() {
    return new Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        height: 24,
        child: new Text(
          "没有数据了",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14, color: Colors.black26),
        ),
      ),
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
