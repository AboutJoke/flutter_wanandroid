import 'package:flutter/material.dart';

class WidgetSearchPage extends StatefulWidget{

  final String searchStr;

  WidgetSearchPage(this.searchStr);

  @override
  State<StatefulWidget> createState() {
    return _WidgetSearchState();
  }

}

class _WidgetSearchState extends State<WidgetSearchPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Text("search"),
    );
  }

}