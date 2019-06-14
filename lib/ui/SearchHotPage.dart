import 'package:flutter/material.dart';
import '../api/HttpServices.dart';
import '../model/HotWordModel.dart';
import '../ui/SearchPageUI.dart';

class SearchHotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchResultState();
  }
}

class _SearchResultState extends State<SearchHotPage> {
  List<Widget> hotKeyWidgets = new List();

  @override
  void initState() {
    super.initState();
    _getHotKey();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: new Text(
            "大家都在搜",
            style: new TextStyle(fontSize: 14),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            children: hotKeyWidgets,
          ),
        )
      ],
    );
  }

  Widget hotKey(String text) {
    return new ActionChip(
        label: new Text(text),
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(new MaterialPageRoute(builder: (context) {
            return new WidgetSearchPage(text);
          }));
        });
  }

  Future<Null> _getHotKey() async {
    CommonService().getSearchHotWord((HotWordModel _hotWordData) {
      setState(() {
        List<HotWordData> data = _hotWordData.data;
        hotKeyWidgets.clear();

        for (var value in data) {
          hotKeyWidgets.add(hotKey(value.name));
        }
      });
    });
  }
}
