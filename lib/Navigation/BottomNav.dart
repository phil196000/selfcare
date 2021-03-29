import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Screens/Blog.dart';
import 'package:selfcare/Screens/Chat.dart';
import 'package:selfcare/Screens/Home.dart';
import 'package:selfcare/Screens/Settings.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

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
      Chat(
        hidenavbar: (val) {
          print(val);
          this.setState(() {
            _hideNavBar = val;
          });
        },
      ),
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
    return Scaffold(body: KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return PersistentTabView.custom(
          context,
          controller: _controller,
          screens: _buildScreens(),

          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: false,

          hideNavigationBar: _hideNavBar,
          margin: EdgeInsets.zero,

          bottomScreenMargin: 0.0,

          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          itemCount: 4,

          customWidget: CustomNavBarWidget(
            items: _navBarsItems(),
            selectedIndex: selected,
            onItemSelected: changeToBottomTab,
            key: Key('value'),
          ),
          // Choose the nav bar style with this property
        );
      },
    ));
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

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, int unreadCount) {
    return Stack(children: [
      Container(
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
                          color: defaultColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          )),
      Visibility(
        visible: item.title == 'Chat' && unreadCount != null && unreadCount > 0,
        child: Positioned(
          right: isSelected ? 0 : 35,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
                color: defaultColors.darkRed,
                boxShadow: [
                  BoxShadow(
                      color: defaultColors.shadowColorGrey,
                      offset: Offset(0, 5),
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: WhiteText(
              size: 8,
              text: unreadCount.toString(),
            ),
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
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
                    child: _buildItem(item, selectedIndex == index,
                        state.chatsModel!.user_unread_count),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
