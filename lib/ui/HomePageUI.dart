import 'package:flutter/material.dart';
import 'DrawWidgetUI.dart';

class HomePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePageUI> {
  List<String> _data = new List();

  void _getData() {}

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
              itemCount: _data.length + 2),
          onRefresh: _getData),
      drawer: WidgetDraw(),
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        height: 200,
        color: Colors.grey,
        child: null,
      );
    }

    if (index - 1 < _data.length) {
      return InkWell(
        onTap: null,
        child: new Column(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(left: 16, top: 16),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "anchor",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    new Expanded(
                        child: new Text(
                      "time",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ))
                  ],
                )),
            new Container(
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: new Text(
                "title-tiele-title-tiele",
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: new Text(
                "category",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          ],
        ),
      );
    }
    return _getMoreWidget();
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
}
