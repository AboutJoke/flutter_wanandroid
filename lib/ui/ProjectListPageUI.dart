import 'package:flutter/material.dart';
import '../model/ProjectTreeModel.dart';
import '../model/ProjectListModel.dart';
import '../api/HttpServices.dart';
import '../utils/RouteUtil.dart';
import '../utils/timeline_util.dart';
import '../widget/CommonListView.dart';

class ProjectListPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectListPageUI>
    with TickerProviderStateMixin {
  List<ProjectTreeData> _list = new List();
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
    CommonService().getProjectTree((ProjectTreeModel _model) {
      setState(() {
        _list = _model.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(length: _list.length, vsync: this);

    return new Scaffold(
      appBar: new AppBar(
        title: new TabBar(
          controller: _tabController,
          tabs: _list.map((ProjectTreeData item) {
            return new Tab(
              text: item.name,
            );
          }).toList(),
          isScrollable: true,
        ),
      ),
      body: new TabBarView(
        children: _list.map((ProjectTreeData item) {
          return ProjectDetailList(id: item.id);
        }).toList(),
        controller: _tabController,
      ),
    );
  }
}

// ignore: must_be_immutable
class ProjectDetailList extends StatefulWidget {
  int id;

  ProjectDetailList({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ProjectDetailState();
  }
}

class _ProjectDetailState extends State<ProjectDetailList> {
  List<ProjectTreeListDatas> _data = new List();
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
    CommonService().getProjectList((ProjectTreeListModel _model) {
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
      CommonService().getProjectList((ProjectTreeListModel _model) {
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
        _onItemClick(_data[index]);
      },
    );
  }

  void _onItemClick(ProjectTreeListDatas itemData) {
    RouteUtils.toWebView(
        context: context,
        title: itemData.title,
        url: itemData.link,
        author: itemData.author,
        isCollect: itemData.collect);
  }

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

  Widget _newsRow(ProjectTreeListDatas item) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Image.network(
              item.envelopePic,
              width: 70,
              height: 120,
              fit: BoxFit.fill,
            )),
        Expanded(
          child: new Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        item.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ))
                    ],
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        item.desc,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                      ))
                    ],
                  )),
              new Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
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
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
