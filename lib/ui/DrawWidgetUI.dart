import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/GlobalConfig.dart';

class WidgetDraw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WidgetDrwState();
  }
}

class _WidgetDrwState extends State<WidgetDraw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          new ListTile(
            title: new Text(
              "我的收藏",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(Icons.collections,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {},
          ),
          new ListTile(
            title: new Text(
              "常用网站",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(
              Icons.web,
              color: GlobalConfig.themeData.accentColor,
              size: 22.0,
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Text(
              "TODO",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(
              Icons.today,
              color: GlobalConfig.themeData.accentColor,
              size: 22.0,
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Text(
              "夜间模式",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(
              Icons.wb_sunny,
              color: GlobalConfig.themeData.accentColor,
              size: 22.0,
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Text(
              "设置",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(
              Icons.settings,
              color: GlobalConfig.themeData.accentColor,
              size: 22.0,
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Text(
              "关于",
              textAlign: TextAlign.left,
            ),
            leading: new Icon(
              Icons.people,
              color: GlobalConfig.themeData.accentColor,
              size: 22.0,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
