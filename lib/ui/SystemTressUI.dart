import 'package:flutter/material.dart';
import '../api/HttpServices.dart';
import '../model/SystemTreeModel.dart';
import '../utils/RouteUtil.dart';
import 'SystemTreeDeatilUI.dart';

class SystemTreeUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SystemTreeState();
  }
}

class _SystemTreeState extends State<SystemTreeUI> {
  List<SystemTreeData> data = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(
          child: new ListView.separated(
              itemBuilder: _rendRow,
              separatorBuilder: (BuildContext context, int index) {
                return new Container(
                  height: 0.5,
                  color: Colors.black26,
                );
              },
              itemCount: data.length),
          onRefresh: _getData),
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    if (index < data.length) {
      return new InkWell(
        onTap: () {
          _onItemClick(data[index]);
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      data[index].name,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: _buildContent(data[index].children),
                  ),
                ],
              ),
            )),
            new Icon(Icons.keyboard_arrow_right),
          ],
        ),
      );
    }

    return null;
  }

  Widget _buildContent(List<SystemTreeChild> children) {
    List<Widget> widgets = new List();
    Widget content;
    for (var value in children) {
      widgets.add(hotKey(value.name));
    }

    content = new Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: widgets,
    );

    return content;
  }

  Widget hotKey(String text) {
    return new Chip(
      label: new Text(text),
    );
  }

  void _onItemClick(SystemTreeData data) {
    RouteUtils.push(context, new SystemTreeDetail(new ValueKey(data)));
  }

  Future<Null> _getData() async {
    CommonService().getSystemTree((SystemTreeModel _sysModel) {
      setState(() {
        data = _sysModel.data;
      });
    });
  }
}
