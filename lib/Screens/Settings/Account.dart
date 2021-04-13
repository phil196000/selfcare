import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/DarkBlueText.dart';
import 'package:selfcare/CustomisedWidgets/DarkGreenText.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/DefaultInput.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetUserAction.dart';
import 'package:selfcare/redux/AppState.dart';

class Account extends StatefulWidget {
  final String option;
  final UserModel? userModel;

  Account({this.option = 'Edit', this.userModel});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late TextEditingController full_name = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController phone = TextEditingController();
  late TextEditingController age = TextEditingController();
  late TextEditingController area = TextEditingController();

  late TextEditingController password = TextEditingController();
  late TextEditingController confirm = TextEditingController();
  String? region;
  String? gender;
  bool is_active = true;
  List<String> checked = [];

//Page View
  late PageController pageController;
  int page = 0;

//errors
  Map<String, dynamic> full_name_error = {'visible': false, 'message': null};
  Map<String, dynamic> email_error = {'visible': false, 'message': null};
  Map<String, dynamic> phone_error = {'visible': false, 'message': null};

  Map<String, dynamic> netWorkError = {'visible': false, 'message': ''};

//firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword({required UserModel userModel}) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(userModel.user_id);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userModel.email, password: userModel.password);
      if (userCredential.user != null) {
        userCredential.user!.updatePassword(password.text.trim()).then((value) {
          // final password_crypt = Crypt.sha256(
          //   password.text.trim(),
          // ).toString();
          users.update({'password': password.text.trim()}).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // onVisible: () =>
              //     Timer(Duration(seconds: 2), () => widget.closeModal()),
              backgroundColor: Colors.green,
              content: Container(
                // color: Colors.yellow,
                child: WhiteText(
                  text: 'Password updated Successfully',
                ),
              ),
              duration: Duration(milliseconds: 2000),
            ));
          });
        });

        // userCredential.user!.updateProfile(
        //   displayName: full_name.text.trim(),
        //
        // );

      }
    } on FirebaseAuthException catch (e) {
      _showMyDialogError(message: e.toString());
      print(e);
      // if (e.code == 'weak-password') {
      //   print('The password provided is too weak.');
      //   _showMyDialogError(message: 'The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      //   postUserdata();
      //   // _showMyDialogError(
      //   //     message: 'The account already exists for that email');
      // }
    } catch (e) {
      _showMyDialogError(message: e.toString());
      print(e);
    }
  }

  void updateUserProfile(
      {bool updateEmail = false,
      BuildContext? cont,
      required UserModel userModel}) async {
    // DocumentReference users =
    //     FirebaseFirestore.instance.collection('users').doc(userModel.user_id);
    log(userModel.user_id, name: 'inside update user profile');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userModel.email, password: userModel.password);
      if (userCredential.user != null) {
        if (updateEmail) {
          userCredential.user!
              .updateEmail(email.text.trim().toLowerCase())
              .then((value) {
            postUserProfileUpdate(
                updateEmail: true, cont: cont, userModel: userModel);
          });
        } else {
          postUserProfileUpdate(cont: cont, userModel: userModel);
          // postUserdata();
        }

        // userCredential.user!.updateProfile(
        //   displayName: full_name.text.trim(),
        //
        // );

      }
    } on FirebaseAuthException catch (e) {
      _showMyDialogError(message: e.toString());
      print(e);
    } catch (e) {
      _showMyDialogError(message: e.toString());
      print(e);
    }
  }

  void postUserProfileUpdate(
      {bool updateEmail = false,
      BuildContext? cont,
      required UserModel userModel}) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(userModel.user_id);
    // final password_crypt = Crypt.sha256(
    //   password.text.trim(),
    // ).toString();
    users.update({
      'full_name': full_name.text.trim(),
      'email': updateEmail ? email.text.trim().toLowerCase() : userModel.email,
      'age': int.parse(age.text),
      'country': 'Ghana',
      'is_active': is_active,
      'phone_number': phone.text,
      'gender': gender,
      'roles': checked,
      'location': {'name': area.text.toUpperCase().trim(), 'region': region},
      'updated': FieldValue.arrayUnion([
        {
          'updated_by': userModel.user_id,
          'updated_on': DateTime.now().millisecondsSinceEpoch
        }
      ])
    }).then((value) {
      getIt
          .get<Store<AppState>>()
          .dispatch(GetUserAction(email: email.text.trim().toLowerCase()));
      getIt.get<Store<AppState>>().dispatch(GetUserEditAction(
              userEditModel: UserModel(
                  user_id: userModel.user_id,
                  created_at: userModel.created_at,
                  added_by: userModel.added_by,
                  updated: userModel.updated,
                  full_name: full_name.text.trim(),
                  email: updateEmail
                      ? email.text.trim().toLowerCase()
                      : userModel.email,
                  age: int.parse(age.text),
                  country: 'Ghana',
                  is_active: is_active,
                  phone_number: phone.text,
                  gender: gender!,
                  roles: checked,
                  password: userModel.password,
                  location: {
                'name': area.text.toUpperCase().trim(),
                'region': region
              })));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // onVisible: () =>
        //     Timer(Duration(seconds: 3), () => Navigator.of(cont!).pop()),
        backgroundColor: Colors.green,
        content: Container(
          // color: Colors.yellow,
          child: WhiteText(
            text: 'Profile updated Successfully',
          ),
        ),
        duration: Duration(milliseconds: 2000),
      ));
    }).catchError((error) {
      _showMyDialogError(message: error.toString());
    });
  }

  void checkUser(
      {bool create = true, BuildContext? cont, required UserModel userModel}) {
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
        if (create) {
        } else {
          updateUserProfile(
              userModel: userModel,
              updateEmail: userModel.email != email.text.trim().toLowerCase(),
              cont: cont);
        }
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
    pageController = PageController(initialPage: 0);

    full_name = TextEditingController(text: widget.userModel!.full_name);
    email = TextEditingController(text: widget.userModel!.email);
    phone = TextEditingController(text: widget.userModel!.phone_number);
    age = TextEditingController(text: widget.userModel!.age.toString());
    area = TextEditingController(text: widget.userModel!.location['name']);
    region = widget.userModel!.location['region'];
    // region =
    //     TextEditingController(text: widget.userModel!.location['region']);
    // password = TextEditingController(text: widget.userModel!.password);
    // confirm = TextEditingController(text: widget.userModel!.password);
    setState(() {
      gender = widget.userModel!.gender;
      checked = widget.userModel!.roles;
      is_active = widget.userModel!.is_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuildContext dupContext = context;
    return StoreConnector(
      builder: (context, AppState state) {
        log(state.userModelEdit!.full_name, name: 'user name');
        UserModel updateUserModelEdit = state.userModelEdit!;
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: DefaultColors().green,
              title: Text('Account'),
              actions: [
                IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      if (page == 0) {
                        log(region.toString());
                        if (full_name.text.length > 2 &&
                            email.text.contains('@') &&
                            email.text.contains('.') &&
                            email.text.length > 6 &&
                            phone.text.length == 10 &&
                            int.parse(age.text.length == 0 ? '0' : age.text) >
                                0 &&
                            gender != null &&
                            area.text.length > 0 &&
                            region != null &&
                            checked.length > 0) {
                          // log(state.userModelEdit!.full_name,
                          //     name: full_name.text);
                          if (state.userModelEdit!.full_name !=
                                  full_name.text.trim() ||
                              state.userModelEdit!.email !=
                                  email.text.trim().toLowerCase() ||
                              state.userModelEdit!.age.toString() != age.text ||
                              state.userModelEdit!.phone_number != phone.text ||
                              state.userModelEdit!.is_active != is_active ||
                              state.userModelEdit!.roles.length !=
                                  checked.length ||
                              '${state.userModelEdit!.location['name']}'
                                      .toUpperCase() !=
                                  area.text.trim().toUpperCase() ||
                              state.userModelEdit!.location['region'] !=
                                  region) {
                            if (state.userModelEdit!.email !=
                                email.text.trim().toLowerCase()) {
                              log('email section ran');
                              checkUser(
                                  cont: context,
                                  create: false,
                                  userModel: state.userModelEdit!);
                            } else {
                              log('i am supposed to be the one running',
                                  name: updateUserModelEdit.user_id +
                                      'it seems so');

                              updateUserProfile(
                                  cont: context,
                                  userModel: updateUserModelEdit);
                            }

                            log('change made');
                          } else {
                            _showMyDialogError(message: 'No changes made');
                          }
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
                                                  : int.parse(age.text.length ==
                                                                  0
                                                              ? '0'
                                                              : age.text) <
                                                          1
                                                      ? 'Age must be greater than 1'
                                                      : gender == null
                                                          ? 'Gender not selected'
                                                          : area.text.length < 1
                                                              ? 'Area must be provided'
                                                              : region == null
                                                                  ? 'Region must be provided'
                                                                  : checked.length ==
                                                                          0
                                                                      ? 'Role must be assigned'
                                                                      : password.text.length <
                                                                              8
                                                                          ? 'Password must be 8 or more characters'
                                                                          : confirm.text.length < 8
                                                                              ? 'Confirm Password must be 8 or more characters'
                                                                              : 'Password and Confirm password not equal');
                        }
                      } else {
                        if (password.text.length > 7 &&
                            confirm.text.length > 7 &&
                            password.text == confirm.text) {
                          updatePassword(userModel: state.userModelEdit!);
                        } else {
                          _showMyDialogError(
                              message: password.text.length < 8
                                  ? 'Password must be 8 or more characters'
                                  : confirm.text.length < 8
                                      ? 'Confirm Password must be 8 or more characters'
                                      : 'Password and Confirm password not equal');
                        }
                      }
                    })
              ],
            ),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Visibility(
                    visible: widget.option == 'Edit' &&
                        state.userModel!.user_id !=
                            state.userModelEdit!.user_id,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                            color: page == 0
                                ? DefaultColors().shadowColorRed
                                : Colors.transparent,
                            child: TextButton(
                                onPressed: () {
                                  pageController.animateToPage(0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                  setState(() {
                                    page = 0;
                                  });
                                },
                                child: DarkRedText(text: 'Profile')),
                          )),
                          Expanded(
                              child: Container(
                                  color: page == 1
                                      ? DefaultColors().shadowColorRed
                                      : Colors.transparent,
                                  child: TextButton(
                                      onPressed: () {
                                        pageController.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut);
                                        setState(() {
                                          page = 1;
                                        });
                                      },
                                      child: DarkRedText(
                                          text: 'Change Password'))))
                        ],
                      ),
                    )),
                Expanded(
                    child: PageView(
                  controller: pageController,
                  onPageChanged: (int p) {
                    setState(() {
                      page = p;
                    });
                  },
                  children: [
                    ListView(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 60),
                      children: [
                        DefaultInput(
                            keyboardType: TextInputType.name,
                            controller: full_name,
                            hint: 'Full Name',
                            error: full_name_error),
                        SizedBox(
                          height: 10,
                        ),
                        DefaultInput(
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            hint: 'Email',
                            error: full_name_error),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          boxShadow: [
                                            // BoxShadow(
                                            //     color: DefaultColors().shadowColorGrey,
                                            //     offset: Offset(0, 5),
                                            //     blurRadius: 10)
                                          ]),
                                      margin: EdgeInsets.only(top: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: DropdownButton<String>(
                                        value: gender,

                                        icon: Icon(
                                            Icons.keyboard_arrow_down_outlined),
                                        iconSize: 24,
                                        elevation: 16,
                                        isExpanded: true,

                                        hint: Text('Select a gender'),
                                        style:
                                            TextStyle(color: Colors.deepPurple),
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
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                  controller: area,
                                  hint: 'Area',
                                  error: full_name_error),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RedText(
                                    text: 'Region',
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButton<String>(
                                      value: region,

                                      icon: Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      iconSize: 24,
                                      elevation: 16,
                                      isExpanded: true,

                                      hint: Text('Select a Region'),
                                      style:
                                          TextStyle(color: Colors.deepPurple),
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
                                          region = newValue!;
                                        });
                                      },
                                      items: [
                                        'Ashanti',
                                        'Bono Region',
                                        'Bono East',
                                        'Ahafo',
                                        'Central',
                                        'Eastern',
                                        'Greater Accra',
                                        'Northern',
                                        'Savannah',
                                        'North East',
                                        'Upper East',
                                        'Upper West',
                                        'Volta',
                                        'Oti',
                                        'Western',
                                        'Western North'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
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
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: widget.option != 'Edit',
                          child: Flex(
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
                        ),
                        // Padding(
                        //     padding: EdgeInsets.only(top: 10),
                        //     child: RedText(
                        //       text: 'User status',
                        //     )),
                        // Theme(
                        //   data: ThemeData(
                        //       focusColor: DefaultColors().green,
                        //       unselectedWidgetColor: is_active
                        //           ? DefaultColors().primary
                        //           : DefaultColors().green,
                        //       disabledColor: !is_active
                        //           ? DefaultColors().primary
                        //           : DefaultColors().green),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Container(
                        //         child: Row(
                        //           children: [
                        //             Radio(
                        //               value: true,
                        //               groupValue: is_active,
                        //               onChanged: is_active
                        //                   ? null
                        //                   : (bool? value) {
                        //                 setState(() {
                        //                   is_active = value!;
                        //                 });
                        //               },
                        //             ),
                        //             DarkGreenText(text: 'Active')
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         child: Row(
                        //           children: [
                        //             Radio(
                        //               activeColor: DefaultColors().primary,
                        //               value: false,
                        //               groupValue: is_active,
                        //               onChanged: !is_active
                        //                   ? null
                        //                   : (bool? value) {
                        //                 setState(() {
                        //                   is_active = value!;
                        //                 });
                        //               },
                        //             ),
                        //             RedText(text: 'Not Active')
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // RedText(
                        //   text: 'User Roles',
                        // ),
                        // Row(
                        //   // direction: Axis.horizontal,
                        //     children: rolesList.map((e) {
                        //       return Row(
                        //         children: [
                        //           Checkbox(
                        //             onChanged: (bool? value) {
                        //               setState(() {
                        //                 if (value!) {
                        //                   checked.add(e.toUpperCase());
                        //                 } else {
                        //                   checked.remove(e.toUpperCase());
                        //                 }
                        //
                        //                 // checked[rolesList.indexOf(e)] = value!;
                        //               });
                        //             },
                        //             // tristate: i == 1,
                        //             value: checked.contains(
                        //                 e.toUpperCase()),
                        //           ),
                        //           Text(
                        //             e,
                        //           ),
                        //         ],
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //       );
                        //     }).toList())
                      ],
                    ),
                    if (widget.option == 'Edit' &&
                        state.userModel!.user_id !=
                            state.userModelEdit!.user_id)
                      ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        children: [
                          Container(
                            child: DefaultInput(
                                controller: password,
                                hint: 'Password',
                                error: full_name_error),
                          ),
                          Container(
                            child: DefaultInput(
                                controller: confirm,
                                hint: 'Confirm Password',
                                error: full_name_error),
                          )
                        ],
                      )
                  ],
                ))
              ],
            ));
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
