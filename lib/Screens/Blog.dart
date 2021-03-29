import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                DarkBlueText(text: 'Today'),
                Hero(
                    tag: 'tip1',
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: defaultColors.darkblue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: defaultColors.shadowColorGrey,
                                offset: Offset(0, 5),
                                blurRadius: 10)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WhiteText(text: 'Title of Tip'),
                          SizedBox(
                            height: 10,
                          ),
                          WhiteText(
                              size: 10,
                              weight: FontWeight.normal,
                              text:
                                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Row(
                                  children: [
                                    WhiteText(
                                      text: 'Read More',
                                      size: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: defaultColors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 5),
                                                blurRadius: 10,
                                                color: defaultColors
                                                    .shadowColorGrey)
                                          ]),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: defaultColors.darkblue,
                                        title: const Text('Tip Title'),
                                        leading: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ),
                                      body: Hero(
                                          tag: 'tip1',
                                          child: Container(
                                              // The blue background emphasizes that it's a new route.
                                              color: Colors.lightBlueAccent,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              alignment: Alignment.topLeft,
                                              child: WhiteText(
                                                text: 'hello i am test',
                                              ))),
                                    );
                                  }));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
