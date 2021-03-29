import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:selfcare/CustomisedWidgets/PrimaryButton.dart';
import 'package:selfcare/Screens/Login.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

final List<dynamic> imgList = [
  {
    'image': 'lib/Assets/onboarding/measure.png',
    'msg':
        'Record and view your blood sugar, blood glucose and weight over time'
  },
  {
    'image': 'lib/Assets/onboarding/pdf.png',
    'msg': 'Generate health records in a PDF form'
  },
  {
    'image': 'lib/Assets/onboarding/chat.png',
    'msg': 'Chat with our experts at anytime you want'
  },
  {
    'image': 'lib/Assets/onboarding/tip.png',
    'msg':
        'Get health tips on prevention and management of diabetes, hypertension and obesity'
  },
];

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
              items: imgList
                  .map((e) => Stack(children: [
                        Image.asset(
                          e['image'],
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.darken,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        Positioned.fill(
                            bottom: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.25),
                                        border: Border.all(width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      e['msg'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]))
                      ]))
                  // )
                  .toList(),
              options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  // enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  })),
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(child: Image.asset('lib/Assets/logo.png'))),
              Spacer(
                flex: 8,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ...imgList.map((e) => Opacity(
                                  opacity:
                                      _current == imgList.indexOf(e) ? 1 : 0.5,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    height: 8,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x4cd20000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ))),
                            ],
                          ),
                          PrimaryButton(
                            onPressed: () {
                              log('i work'); // pushNewScreen(context, screen: Login(),pageTransitionAnimation: );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                            text: 'Get Started',
                          )
                        ],
                      )))
            ],
          )
        ],
      )),
    );
  }
}
