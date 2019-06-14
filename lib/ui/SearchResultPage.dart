import 'package:flutter/material.dart';
import '../model/ArticleModel.dart';
import '../api/HttpServices.dart';
import '../utils/RouteUtil.dart';
import '../utils/timeline_util.dart';

// ignore: must_be_immutable
class SearchResultPage extends StatefulWidget {
  String id;

  SearchResultPage(ValueKey<String> key) : super(key: key) {
    this.id = key.value.toString();
  }

  @override
  State<StatefulWidget> createState() {
    return new _SearchResultState();
  }
}

class _SearchResultState extends State<SearchResultPage> {
  List<Article> data = new List();
  int page = 0;
  ScrollController _scrollController = new ScrollController();

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
            itemCount: data.length + 1,
            controller: _scrollController,
          ),
          onRefresh: _getData),
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    if (index < data.length) {
      return _itemView(context, index);
    }
    return _getMoreWidget();
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        _onItemClick(data[index]);
      },
      child: _newsRow(data[index]),
    );
  }

  Widget _newsRow(Article item) {
    return new Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.title
                        .replaceAll("<em class='highlight'>", "")
                        .replaceAll("<\/em>", ""),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  item.desc,
                  style: TextStyle(fontSize: 12),
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
                  style: TextStyle(fontSize: 12),
                ),
                new Expanded(
                  child: new Text(
                    TimelineUtil.format(item.publishTime),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )),
      ],
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

  void _onItemClick(Article article) {
    RouteUtils.toWebView(context, article.title, article.link);
  }

  Future<Null> _getData() async {
    page = 0;
    CommonService().getSearchResult((ArticleModel _articleModel) {
      setState(() {
        data = _articleModel.data.datas;
      });
    }, page, widget.id);
  }

  Future<Null> _getMoreData() async {
    page++;
    CommonService().getSearchResult((ArticleModel _articleModel) {
      setState(() {
        data = _articleModel.data.datas;
      });
    }, page, widget.id);
  }
}
