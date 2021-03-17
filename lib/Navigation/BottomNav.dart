import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/Screens/Blog.dart';
import 'package:selfcare/Screens/Chat.dart';
import 'package:selfcare/Screens/Home.dart';
import 'package:selfcare/Screens/Settings.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  DefaultColors defaultColors = DefaultColors();
  PersistentTabController? _controller;
  bool? _hideNavBar;
  int selected = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _controller!.addListener(() {
      print(_controller!.index);
      this.setState(() {
        selected = _controller!.index;
      });
    });
    _hideNavBar = false;
  }

  void changeToBottomTab(int tab) {
    this.setState(() {
      selected = tab;
    });
    _controller!.jumpToTab(tab);
    // print(tab.toString());
    // print('object');
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Chat(),
      Blog(),
      Settings(
        hidenavbar: (val) {
          print(val);
          this.setState(() {
            _hideNavBar = val;
          });
        },
      )

      // Search(),
      // Community(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.home,
            color: selected == 0 ? defaultColors.white : defaultColors.primary,
          ),
          title: ("Home"),
          activeColorAlternate: defaultColors.white,
          activeColor: defaultColors.primary,
          inactiveColor: defaultColors.primary,
          contentPadding: 0,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.chat_sharp,
            color: selected == 1 ? defaultColors.white : defaultColors.primary,
          ),
          title: ("Chat"),
          activeColorAlternate: defaultColors.white,
          activeColor: defaultColors.primary,
          inactiveColor: defaultColors.primary,
          contentPadding: 0,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      PersistentBottomNavBarItem(
          icon: Icon(
            CupertinoIcons.news_solid,
            color: selected == 2 ? defaultColors.white : defaultColors.primary,
          ),
          title: ("Blog"),
          activeColorAlternate: defaultColors.white,
          activeColor: defaultColors.primary,
          inactiveColor: defaultColors.primary,
          contentPadding: 0,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.settings,
            color: selected == 3 ? defaultColors.white : defaultColors.primary,
          ),
          title: ("Settings"),
          activeColorAlternate: defaultColors.white,
          activeColor: defaultColors.primary,
          inactiveColor: defaultColors.primary,
          contentPadding: 0,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Navigation Bar Demo')),
      // drawer: Drawer(
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         const Text('This is the Drawer'),
      //       ],
      //     ),
      //   ),
      // ),
      body: PersistentTabView.custom(
        context,
        controller: _controller,
        screens: _buildScreens(),

        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: _hideNavBar,
        margin: EdgeInsets.zero,

        bottomScreenMargin: 0.0,
        // onWillPop: () async {
        //   await showDialog(
        //     context: context,
        //     useSafeArea: true,
        //     builder: (context) => Container(
        //       height: 50.0,
        //       width: 50.0,
        //       color: Colors.white,
        //       child: RaisedButton(
        //         child: Text("Close"),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ),
        //   );
        //   return false;
        // },

        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        itemCount: 4,
// selectedTabScreenContext: ,
        customWidget: CustomNavBarWidget(
          items: _navBarsItems(),
          selectedIndex: selected,
          onItemSelected: changeToBottomTab,
          key: Key('value'),
        ),
        // Choose the nav bar style with this property
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget({
    required Key key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  DefaultColors defaultColors = DefaultColors();

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: isSelected ? defaultColors.primary : defaultColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, isSelected ? 5 : 0),
                blurRadius: isSelected ? 10 : 0,
                color: isSelected
                    ? defaultColors.shadowColorRed
                    : Colors.transparent)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(child: item.icon),
          Visibility(
              visible: isSelected,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  item.title,
                  style: TextStyle(
                      color: defaultColors.white, fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            int index = items.indexOf(item);
            return Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(index);
                },
                child: _buildItem(item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
