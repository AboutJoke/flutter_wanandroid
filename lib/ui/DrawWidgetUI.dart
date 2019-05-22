import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/GlobalConfig.dart';
import 'login/LoginPageUI.dart';
import '../common/Application.dart';
import '../event/LoginEvent.dart';
import '../common/User.dart';
import '../GlobalConfig.dart';

class WidgetDraw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WidgetDrwState();
  }
}

class _WidgetDrwState extends State<WidgetDraw> {
  @override
  void initState() {
    super.initState();
    this.registerLoginEvent();
  }

  void registerLoginEvent() {
    Application.eventBus.on<LoginEvent>().listen((event) {
      changeUI();
    });
  }

  changeUI() async {
    setState(() {
      print(User.singleton.userName);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new InkWell(
              // 水波纹
              child: Text(
                User.singleton.userName == null
                    ? "sign in"
                    : User.singleton.userName,
                style: TextStyle(
                    fontSize: 16,
                    color: GlobalConfig.themeDataLight.primaryColor),
              ),
              onTap: () {
                if (User.singleton.userName != null) {
                  return null;
                } else {
                  onLoginClick();
                }
              },
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/avatar.jpg'),
            ),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                image: DecorationImage(
                  image: AssetImage(GlobalConfig.dark
                      ? "images/bg_adrk.png"
                      : "images/bg_light.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey[800].withOpacity(0.6), BlendMode.hardLight),
                )),
          ),
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

  void onLoginClick() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new LoginPageUI();
    }));
  }
}
