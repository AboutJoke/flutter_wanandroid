import 'package:flutter/material.dart';
import '../api/HttpServices.dart';
import '../model/BannerModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../utils/RouteUtil.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BannerWidgetState();
  }
}

class _BannerWidgetState extends State<BannerWidget> {
  List<BannerData> _list = new List();

  @override
  void initState() {
    super.initState();
    _list.add(null);
    _getBanner();
  }

  Future<Null> _getBanner() async {
    CommonService().getBanner((BannerModel _bannerModel) {
      if (_bannerModel.errorCode == CommonService.RESULT_OK &&
          _bannerModel.data.length > 0) {
        setState(() {
          _list = _bannerModel.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Swiper(
        itemHeight: 100,
        itemCount: _list.length,
        autoplay: true,
        pagination: new SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          if (_list[index] == null || _list[index].imagePath == null) {
            return new Container(
              color: Colors.grey[100],
            );
          } else {
            return buildItemImageWidget(context, index);
          }
        },
      ),
    );
  }

  Widget buildItemImageWidget(BuildContext context, int index) {
    return new InkWell(
      onTap: () {
        RouteUtils.toWebView(
            context: context, title: _list[index].title, url: _list[index].url);
      },
      child: new Container(
        child: new Image.network(
          _list[index].imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
