import 'package:flutter/material.dart';

class MyBottomNavigation extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChange;

  MyBottomNavigation({Key key, this.index: 0, @required this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyBottomNavigationState();
  }
}


class _MyBottomNavigationState extends State<MyBottomNavigation> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  void _onTapHandler(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapHandler,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.streetview),
            title: Text('体系'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('公众号'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            title: Text('导航'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('项目'),
          ),
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
