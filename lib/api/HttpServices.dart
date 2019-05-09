import 'package:flutter_wanandroid/api/Api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/model/ArticleModel.dart';
import 'package:flutter_wanandroid/model/BannerModel.dart';
import 'package:flutter_wanandroid/model/UserModel.dart';
import 'DioManager.dart';
import 'package:flutter_wanandroid/common/User.dart';

class CommonService {
  // ignore: non_constant_identifier_names
  static final int RESULT_OK = 0;

  /// 登录
  void login(Function callback, String _username, String _password) async {
    FormData formData =
        new FormData.from({"username": _username, "password": _password});
    DioManager.singleton.dio
        .post(Api.USER_LOGIN, data: formData, options: _getOptions())
        .then((response) {
      callback(UserModel(response.data), response);
    });

//    try {
//      Response response = await Dio().post(Api.USER_LOGIN, data: formData);
//      print(response);
//    } on DioError catch (e) {
//      // The request was made and the server responded with a status code
//      // that falls out of the range of 2xx and is also not 304.
//      if (e.response != null) {
//        print(e.response.data);
//        print(e.response.headers);
//        print(e.response.request);
//      } else {
//        // Something happened in setting up or sending the request that triggered an Error
//        print(e.request);
//        print(e.message);
//      }
//    }
  }

  /// banner
  void getBanner(Function callback) async {
    DioManager.singleton.dio
        .get(Api.HOME_BANNER, options: _getOptions())
        .then((response) {
      callback(BannerModel(response.data));
    });
  }

  ///文章
  void getArticleList(Function callback, int _page) async {
    DioManager.singleton.dio
        .get(Api.HOME_ARTICLE_LIST + "$_page/json", options: _getOptions())
        .then((response) {
      callback(ArticleModel(response.data));
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}
