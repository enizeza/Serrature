import 'package:firebase_auth/firebase_auth.dart';
import 'package:serrature/pages/user_keys.dart';
import 'package:serrature/models/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:serrature/main.dart';

class AppBottomNavigation extends StatefulWidget {
  VoidCallback? onPressed;

  AppBottomNavigation({Key? key}) : super(key: key);
  @override
  _AppBottomNavigationState createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  List<BottomBarItem> items = [];

  @override
  void initState() {
    items = [
      BottomBarItem(
        icon: Icons.home,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
      ),
      BottomBarItem(
        icon: Icons.person,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ()),
          // );
        },
      ),
      BottomBarItem(
        icon: Icons.logout,
        onPressed: () {
          //SignOutButton();
          FirebaseAuth.instance.signOut();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ()),
          // );
        },
      ),
      BottomBarItem(
        icon: Icons.key,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => (UserKeys())),
          );
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 12.0,
        bottom: 12.0,
        right: 12.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      height: 65.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .map(
              (BottomBarItem item) => getBottomWidgetItem(item),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomWidgetItem(BottomBarItem item) {
  return Container(
    height: 62.0,
    width: 62.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent,
    ),
    child: AnimatedSwitcher(
      duration: Duration(milliseconds: 450),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: IconButton(
          icon: Icon(
            item.icon,
            color: Colors.white,
          ),
          onPressed: () {
            item.onPressed();
          },
        ),
      ),
    ),
  );
}
