import 'package:flutter/material.dart';


class CommonListView {



//  Widget rendView(BuildContext context, int index, int length, bool isLastPage, bool hasMoreData, Widget itemView) {
//    Widget _renderRow(context, index) {
//      if (index < length) {
//        return itemView;
//      } else if (!isLastPage && hasMoreData) {
//        return _getMoreWidget();
//      } else {
//        return _lastWidget();
//      }
//    }
//    return _renderRow(context, index);
//  }

  static Widget loading() {
    Widget _getMoreWidget() {
      return Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    return _getMoreWidget();
  }

  static Widget noData() {
    Widget _lastWidget() {
      return new Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SizedBox(
          height: 24,
          child: new Text(
            "没有数据了",
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 14, color: Colors.black26),
          ),
        ),
      );
    }
    return _lastWidget();
  }


}