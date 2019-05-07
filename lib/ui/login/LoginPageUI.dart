import 'package:flutter/material.dart';

class LoginPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPageUI> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _userPwdController = new TextEditingController();
  FocusNode _focusNodeDetail = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();

  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _isButton1Disabled;

  @override
  void initState() {
    super.initState();
    _isButton1Disabled = true;
  }

  void _onLogin() {}

  _onTextFileChange() {
    setState(() {
      if ((_formKey.currentState as FormState).validate()) {
        _isButton1Disabled = false;
      } else {
        _isButton1Disabled = true;
      }
    });
  }

  bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    Widget formWidget = Form(
        key: _formKey,
        autovalidate: true,
        onChanged: _onTextFileChange,
        child: new Column(
          children: <Widget>[
            new Container(
              child: TextFormField(
                autofocus: true,
                focusNode: _focusNodeDetail,
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "请输入用户名或邮箱",
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(Icons.person),
                ),
                maxLines: 1,
                validator: (v) {
                  return v.trim().length > 0 ? null : "用户名不能为空";
                },
              ),
            ),
            new Container(
              child: TextFormField(
                focusNode: _focusNodeEmail,
                controller: _userPwdController,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                maxLines: 1,
                validator: (v) {
                  String regexEmail =
                      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
                  if (v.trim().length > 0) {
                    if (!matches(regexEmail, v.trim())) {
                      return "";
                    }
                  } else {
                    return "密码不能为空";
                  }
                },
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
              height: 48,
              width: double.infinity,
              child: new FlatButton( // onPress为null 显示disable状态
                onPressed: _isButton1Disabled
                    ? null
                    : () {
                        _onLogin();
                      },
                child: Text("登录"),
                color: Colors.blue,
                textColor: Colors.white,
                disabledTextColor: Color(0xFFABABAB),
                disabledColor: Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ));

    return new GestureDetector(
      onTap: () {
        _focusNodeDetail.unfocus();
        _focusNodeEmail.unfocus();
      },
      child: new Scaffold(
        resizeToAvoidBottomPadding: false, //控制界面内容 body 是否重新布局来避免底部被覆盖了
        appBar: new AppBar(
          title: Text("登录"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "用户登录",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 14.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "请使用 WanAndroid 账号登录",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                formWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
