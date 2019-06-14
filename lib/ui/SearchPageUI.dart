import 'package:flutter/material.dart';
import 'SearchHotPage.dart';
import 'SearchResultPage.dart';

class WidgetSearchPage extends StatefulWidget {
  final String searchStr;

  WidgetSearchPage(this.searchStr);

  @override
  State<StatefulWidget> createState() {
    return _WidgetSearchState(searchStr);
  }
}

class _WidgetSearchState extends State<WidgetSearchPage> {
  TextEditingController _inputController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  String searchStr;
  SearchResultPage _searchResultPage;
  _WidgetSearchState(this.searchStr)

  @override
  void initState() {
    super.initState();
    setState(() {
      _inputController = new TextEditingController(text: searchStr);
    });
  }

  void _onSearch() {}

  void _onClose() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSearch = new TextField(
      decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "搜索关键词",
          contentPadding: const EdgeInsets.all(8),
          hintStyle: new TextStyle(color: Colors.white)),
      style: new TextStyle(color: Colors.white),
      autofocus: true,
      controller: _inputController,
      focusNode: _focusNode,
      cursorColor: Colors.white30,
    );

    return new Scaffold(
      appBar: new AppBar(
        title: titleSearch,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: _onSearch,
          ),
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: _onClose,
          )
        ],
      ),
      body: (_inputController.text == null || _inputController.text.isEmpty)
          ? new Center(
              child: new SearchHotPage(),
            )
          : _searchResultPage,
    );
  }
}
