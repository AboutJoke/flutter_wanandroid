import 'package:flutter_wanandroid/api/Api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/model/ArticleModel.dart';
import 'package:flutter_wanandroid/model/BannerModel.dart';
import 'package:flutter_wanandroid/model/UserModel.dart';
import '../model/HotWordModel.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../model/WxArticleTitleModel.dart';
import '../model/WxArticleContentModel.dart';
import '../model/NavigationModel.dart';
import '../model/ProjectListModel.dart';
import '../model/ProjectTreeModel.dart';
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

  /// 获取搜索热词
  void getSearchHotWord(Function callback) async {
    DioManager.singleton.dio.get(Api.SEARCH_HOT_WORD, options: _getOptions()).then((response) {
      callback(HotWordModel(response.data));
    });
  }

  /// 获取搜索结果
  void getSearchResult(Function callback,int _page,String _id) async {
    FormData formData = new FormData.from({
      "k": _id,
    });
    DioManager.singleton.dio.post(Api.SEARCH_RESULT+"$_page/json", data: formData, options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }

  /// 获取知识体系列表
  void getSystemTree(Function callback) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE, options: _getOptions()).then((response) {
      callback(SystemTreeModel(response.data));
    });
  }

  /// 获取知识体系列表详情
  void getSystemTreeContent(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE_CONTENT+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(SystemTreeContentModel(response.data));
    });
  }

  /// 获取公众号名称
  void getWxTitleList(Function callback) async {
    DioManager.singleton.dio.get(Api.WX_LIST, options: _getOptions()).then((response) {
      callback(WxArticleTitleModel(response.data));
    });
  }

  /// 获取对应微信公众号下文章
  void getWxArticleList(Function callback,int _id,int _page) async {
    DioManager.singleton.dio.get(Api.WX_ARTICLE_LIST+"$_id/$_page/json", options: _getOptions()).then((response) {
      callback(WxArticleContentModel(response.data));
    });
  }

  /// 获取导航列表数据
  void getNavigationList(Function callback) async {
    DioManager.singleton.dio.get(Api.NAVI_LIST, options: _getOptions()).then((response) {
      callback(NavigationModel(response.data));
    });
  }

  /// 获取项目分类
  void getProjectTree(Function callback) async {
    DioManager.singleton.dio.get(Api.PROJECT_TREE, options: _getOptions()).then((response) {
      callback(ProjectTreeModel(response.data));
    });
  }

  /// 获取项目列表
  void getProjectList(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.PROJECT_LIST+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(ProjectTreeListModel(response.data));
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}
