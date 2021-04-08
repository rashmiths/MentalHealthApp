import 'package:MentalHealthApp/screens/home_page.dart';
import 'package:MentalHealthApp/screens/remainder_page.dart';
import 'package:MentalHealthApp/screens/settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  BottomTabs({Key key}) : super(key: key);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _page;
  @override
  void initState() {
    _page = 0;

    super.initState();
  }

  GlobalKey _bottomNavigationKey = GlobalKey();

  Widget build(BuildContext context) {
    //LIST OF TABS
    List<Widget> _children = [
      HomePage(),
      RemainderPage(),
      SettingsPage(),
    ];
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            color: Colors.amber[200],
            backgroundColor: Colors.purple[200],
            key: _bottomNavigationKey,
            items: <Widget>[
              Icon(Icons.home),
              Icon(Icons.alarm),
              Icon(Icons.settings)
            ],
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: _children[_page]),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
