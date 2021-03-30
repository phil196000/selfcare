import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/redux/AppState.dart';

class AddTipsModal extends StatefulWidget {
  final Function? closeModal;

  AddTipsModal({this.closeModal});

  @override
  _AddTipsModalState createState() => _AddTipsModalState();
}

class _AddTipsModalState extends State<AddTipsModal> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  //errors
  Map<String, dynamic> title_error = {'visible': false, 'message': null};
  DefaultColors defaultColors = DefaultColors();

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.close), onPressed: () => widget.closeModal!()),
            backgroundColor: DefaultColors().green,
            title: Text('Add Tip'),
            actions: [
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (titleEditingController.text.length > 1 &&
                        descriptionEditingController.text.length > 1) {
                      DocumentReference tipRef =
                          FirebaseFirestore.instance.collection('tips').doc();
                      tipRef.set({
                        'title': titleEditingController.text.trim(),
                        'description': descriptionEditingController.text.trim(),
                        'created_at': DateTime.now().millisecondsSinceEpoch,
                        'is_deleted': false,
                        'tip_id': tipRef.id
                      }).then((value) {
                        log('message');
                        titleEditingController.text = '';
                        descriptionEditingController.text = '';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        // onVisible: () => Timer(
                        //     Duration(seconds: 2),
                        //         () => Navigator.of(context).pop()),
                        backgroundColor: Colors.green,
                        content: Container(
                          // color: Colors.yellow,
                          child: WhiteText(
                            text: 'Tip successfully added',
                          ),
                        ),
                        duration: Duration(milliseconds: 2000),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        // onVisible: () => Timer(
                        //     Duration(seconds: 2),
                        //         () => Navigator.of(context).pop()),
                        backgroundColor: Colors.red,
                        content: Container(
                          // color: Colors.yellow,
                          child: WhiteText(
                            text: 'Provide required fields',
                          ),
                        ),
                        duration: Duration(milliseconds: 4000),
                      ));
                    }
                  })
            ],
          ),
          body: SafeArea(
              child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: [
              DefaultInput(
                  keyboardType: TextInputType.name,
                  controller: titleEditingController,
                  hint: 'Title',
                  error: title_error),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RedText(text: 'Description'),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: TextField(
                      controller: descriptionEditingController,
                      minLines: 4,
                      maxLines: 8,
                      style: TextStyle(
                          color: defaultColors.darkRed,
                          fontWeight: FontWeight.bold),
                      cursorColor: defaultColors.darkRed,
                      decoration: InputDecoration(
                          fillColor: defaultColors.white,
                          filled: true,
                          // hintText: "Enter Phone number",
                          hintStyle: TextStyle(
                              color: defaultColors.darkRed,
                              fontWeight: FontWeight.normal),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: defaultColors.primary,
                                  width: 2)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(
                                  color: defaultColors.primary, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: defaultColors.primary,
                                  width: 2)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(
                                  color: defaultColors.primary, width: 2))),
                    ),
                  ),
                ],
              )
            ],
          )),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
