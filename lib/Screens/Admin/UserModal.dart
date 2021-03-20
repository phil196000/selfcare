import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Theme/DefaultColors.dart';

class UserFormDialog extends StatefulWidget {
  final Function closeModal;
  final String option;
  final UserModel? userModel;

  UserFormDialog(
      {required this.closeModal, this.option = 'Add', this.userModel});

  @override
  _UserFormDialogState createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late TextEditingController full_name = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController phone = TextEditingController();
  late TextEditingController age = TextEditingController();
  late TextEditingController area = TextEditingController();
  late TextEditingController region = TextEditingController();
  late TextEditingController password = TextEditingController();
  late TextEditingController confirm = TextEditingController();

  String? gender;
  bool is_active = true;
  List<String> checked = [];

//edit
//errors
  Map<String, dynamic> full_name_error = {'visible': false, 'message': null};
  Map<String, dynamic> email_error = {'visible': false, 'message': null};
  Map<String, dynamic> phone_error = {'visible': false, 'message': null};

  Map<String, dynamic> netWorkError = {'visible': false, 'message': ''};

//firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  Future createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.toLowerCase().trim(),
              password: password.text.trim());
      if (userCredential.user != null) {
        postUserdata();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _showMyDialogError(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        postUserdata();
        // _showMyDialogError(
        //     message: 'The account already exists for that email');
      }
    } catch (e) {
      _showMyDialogError(message: e.toString());
      print(e);
    }
  }

  void postUserdata() {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc();
    final password_crypt = Crypt.sha256(password.text.trim(),
            rounds: 10000, salt: 'selfcarepasswordsalt')
        .toString();

    users.set({
      'full_name': full_name.text.trim(),
      'email': email.text.toLowerCase().trim(),
      'age': int.parse(age.text),
      'country': 'Ghana',
      'is_active': is_active,
      'password': password_crypt,
      'phone_number': phone.text,
      'roles': checked,
      'location': {
        'name': area.text.toUpperCase().trim(),
        'region': region.text.toUpperCase().trim()
      },
      'int created_at': DateTime.now().millisecondsSinceEpoch,
      'user_id': users.id,
    }).then((value) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Alert')],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RedText(text: 'User added successfully'),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: DarkRedText(
                      text: 'Press OK to proceed',
                      weight: FontWeight.normal,
                      size: 14,
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    full_name.text = '';
                    email.text = '';
                    password.text = '';
                    phone.text = '';
                    age.text = '';
                    gender = null;
                    area.text = '';
                    region.text = '';
                    password.text = '';
                    confirm.text = '';
                    checked = <String>[];
                  });

                  // Timer(Duration(seconds: 2),
                  //     () => Navigator.of(context).pop());
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      _showMyDialogError(message: error.toString());
    });
  }

  void updateUser() {}

  void checkUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // QuerySnapshot snapshot =
    users
        .where('email', isEqualTo: email.text.toLowerCase().trim())
        // .where('password', isEqualTo: _password.text)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size > 0) {
        _showMyDialogError(message: 'User with similar email exist');
      } else {
        createUser();
      }
    }).catchError((error) {
      log(error.toString());
    });
  }

//Roles
  List<String> rolesList = ['Admin', 'User', 'Manager'];

  Future<void> _showMyDialogError({String message = ''}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Alert')],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RedText(text: message),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: DarkRedText(
                    text: 'Press OK to make changes and save again',
                    weight: FontWeight.normal,
                    size: 14,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.option == 'Edit') {
      full_name = TextEditingController(text: widget.userModel!.full_name);
      email = TextEditingController(text: widget.userModel!.email);
      phone = TextEditingController(text: widget.userModel!.phone_number);
      age = TextEditingController(text: widget.userModel!.age.toString());
      area = TextEditingController(text: widget.userModel!.location['name']);
      region =
          TextEditingController(text: widget.userModel!.location['region']);
      password = TextEditingController(text: widget.userModel!.password);
      confirm = TextEditingController(text: widget.userModel!.password);
      setState(() {
        gender = widget.userModel!.gender;
        checked = widget.userModel!.roles;
        is_active = widget.userModel!.is_active;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => widget.closeModal()),
        backgroundColor: DefaultColors().green,
        title: Text('Add User'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (widget.option == 'Edit') {
                  if (widget.userModel!.is_active != is_active) {
                    _showMyDialogError(message: 'does not matct');
                  }
                } else {
                  if (full_name.text.length > 2 &&
                      email.text.contains('@') &&
                      email.text.contains('.') &&
                      email.text.length > 6 &&
                      phone.text.length == 10 &&
                      int.parse(age.text.length == 0 ? '0' : age.text) > 0 &&
                      gender != null &&
                      area.text.length > 0 &&
                      region.text.length > 0 &&
                      password.text.length > 7 &&
                      confirm.text.length > 7 &&
                      password.text == confirm.text &&
                      checked.length > 0) {
                    checkUser();
                  } else {
                    _showMyDialogError(
                        message: full_name.text.length < 3
                            ? 'Full name should be 3 or more characters'
                            : !email.text.contains('@')
                                ? 'Email must contain @'
                                : !email.text.contains('.')
                                    ? 'Email must contain .'
                                    : email.text.length < 7
                                        ? "Email length must be 7 or more characters"
                                        : phone.text.length < 10
                                            ? 'Phone number must be 10 characters'
                                            : int.parse(age.text.length == 0
                                                        ? '0'
                                                        : age.text) <
                                                    1
                                                ? 'Age must be greater than 1'
                                                : gender == null
                                                    ? 'Gender not selected'
                                                    : area.text.length < 1
                                                        ? 'Area must be provided'
                                                        : region.text.length < 1
                                                            ? 'Region must be provided'
                                                            : password.text
                                                                        .length <
                                                                    8
                                                                ? 'Password must be 8 or more characters'
                                                                : confirm.text
                                                                            .length <
                                                                        8
                                                                    ? 'Confirm Password must be 8 or more characters'
                                                                    : checked.length ==
                                                                            0
                                                                        ? 'Role must be assigned'
                                                                        : 'Password and Confirm password not equal');
                  }
                }
              })
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          DefaultInput(
              controller: full_name, hint: 'Full Name', error: full_name_error),
          SizedBox(
            height: 10,
          ),
          DefaultInput(
              controller: email, hint: 'Email', error: full_name_error),
          SizedBox(
            height: 10,
          ),
          DefaultInput(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: phone,
            hint: 'Phone Number',
            error: full_name_error,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: DefaultInput(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                  controller: age,
                  hint: 'Age',
                  error: full_name_error,
                  keyboardType: TextInputType.number,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RedText(
                        text: 'Gender',
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        decoration: BoxDecoration(
                            color: DefaultColors().white,
                            border: Border.all(
                              width: 2,
                              color: DefaultColors().primary,
                            ),
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [
                              // BoxShadow(
                              //     color: DefaultColors().shadowColorGrey,
                              //     offset: Offset(0, 5),
                              //     blurRadius: 10)
                            ]),
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          value: gender,

                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,

                          hint: Text('Select a gender'),
                          style: TextStyle(color: Colors.deepPurple),
                          // selectedItemBuilder: ,
                          underline: Container(
                            height: 0,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            // getIt.get<Store<AppState>>().dispatch(
                            //     SelectTimeValuesAction(
                            //         screen: widget.title, selected: newValue));
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          items: ['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: DefaultColors().darkblue,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: DarkBlueText(
              text: 'Location',
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 4,
                child: DefaultInput(
                    controller: area, hint: 'Area', error: full_name_error),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 4,
                child: DefaultInput(
                    controller: region, hint: 'Region', error: full_name_error),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 4,
                child: DefaultInput(
                    controller: password,
                    hint: 'Password',
                    error: full_name_error),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 4,
                child: DefaultInput(
                    controller: confirm,
                    hint: 'Confirm Password',
                    error: full_name_error),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: RedText(
                text: 'User status',
              )),
          Theme(
            data: ThemeData(
                focusColor: DefaultColors().green,
                unselectedWidgetColor:
                    is_active ? DefaultColors().primary : DefaultColors().green,
                disabledColor: !is_active
                    ? DefaultColors().primary
                    : DefaultColors().green),
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: is_active,
                        onChanged: is_active
                            ? null
                            : (bool? value) {
                                setState(() {
                                  is_active = value!;
                                });
                              },
                      ),
                      DarkGreenText(text: 'Active')
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Radio(
                        activeColor: DefaultColors().primary,
                        value: false,
                        groupValue: is_active,
                        onChanged: !is_active
                            ? null
                            : (bool? value) {
                                setState(() {
                                  is_active = value!;
                                });
                              },
                      ),
                      RedText(text: 'Not Active')
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RedText(
            text: 'User Roles',
          ),
          Row(
              // direction: Axis.horizontal,
              children: rolesList.map((e) {
            return Row(
              children: [
                Checkbox(
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        checked.add(e.toUpperCase());
                      } else {
                        checked.remove(e.toUpperCase());
                      }

                      // checked[rolesList.indexOf(e)] = value!;
                    });
                  },
                  // tristate: i == 1,
                  value: checked.contains(e.toUpperCase()),
                ),
                Text(
                  e,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          }).toList())
        ],
      ),
    );
    ;
  }
}
