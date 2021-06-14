import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/redux/AppState.dart';

class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {


  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      builder: (context, AppState state) {
        int usersCount = 0;
        int adminCount = 0;
        state.users!.forEach((element) {
          if (element.roles.contains('USER')) {
            usersCount += 1;
          }
          if (element.roles.contains('ADMIN')) {
            adminCount += 1;
          }
        });
        return Scaffold(
          body: SafeArea(
              child: Stack(
                children: [
                  Background(),
                  Positioned.fill(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        children: [
                  // ...state.users!.map((e) {
                  //   return Column(
                  //     children: [
                  //       ListTile(
                  //         leading: Visibility(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Icon(
                  //                 Icons.verified_user,
                  //                 color: DefaultColors().green,
                  //               ),
                  //               DarkRedText(
                  //                 text: 'Current',
                  //                 size: 10,
                  //               )
                  //             ],
                  //           ),
                  //           visible: e.user_id == state.userModel!.user_id,
                  //         ),
                  //         title: Text(e.full_name),
                  //         subtitle: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(e.roles.toString()),
                  //             e.is_active
                  //                 ? DarkGreenText(
                  //               text: 'Active',
                  //               size: 10,
                  //             )
                  //                 : DarkRedText(
                  //               text: 'InActive',
                  //               size: 10,
                  //             )
                  //           ],
                  //         ),
                  //
                  //         // leading: Icon(Icons.label),
                  //         trailing: Container(
                  //           width: MediaQuery.of(context).size.width * 0.4,
                  //           child: Stack(
                  //             children: [
                  //               Visibility(
                  //                   visible: (e.user_id !=
                  //                       state.userModel!.user_id) &&
                  //                       state.unreadList.length != 0 &&
                  //                       unreadValue(
                  //                           unreadList: state.unreadList,
                  //                           usMod: e) !=
                  //                           '0',
                  //                   child: Stack(
                  //                     // overflow: Overflow.visible,
                  //                     clipBehavior: Clip.none,
                  //                     children: [
                  //                       Icon(
                  //                         Icons.chat,
                  //                         color: DefaultColors().primary,
                  //                       ),
                  //                       Positioned(
                  //                           right: 0,
                  //                           top: -5,
                  //                           child: Container(
                  //                             padding: EdgeInsets.symmetric(
                  //                                 horizontal: 5, vertical: 3),
                  //                             decoration: BoxDecoration(
                  //                                 color: DefaultColors().green,
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                       color: DefaultColors()
                  //                                           .shadowColorGrey,
                  //                                       offset: Offset(0, 5),
                  //                                       blurRadius: 10)
                  //                                 ],
                  //                                 borderRadius:
                  //                                 BorderRadius.circular(
                  //                                     10)),
                  //                             child: WhiteText(
                  //                               size: 8,
                  //                               text: unreadValue(
                  //                                   unreadList:
                  //                                   state.unreadList,
                  //                                   usMod: e),
                  //                             ),
                  //                           ))
                  //                     ],
                  //                   )),
                  //               DropdownButton<String>(
                  //                 icon: Icon(Icons.more_vert),
                  //                 value: null,
                  //
                  //                 // isExpanded: false,
                  //
                  //                 underline: Container(
                  //                   height: 0,
                  //                   color: Colors.deepPurpleAccent,
                  //                 ),
                  //                 items: <DropdownMenuItem<String>>[
                  //                   DropdownMenuItem(
                  //                     value: 'Edit',
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(Icons.edit),
                  //                         Text('Edit')
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   DropdownMenuItem(
                  //                     value: 'Record',
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(Icons.file_copy),
                  //                         Text('View Record')
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   DropdownMenuItem(
                  //                     value: 'Chat',
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(Icons.chat),
                  //                         Text('Chat')
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   DropdownMenuItem(
                  //                     value: 'Delete',
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(Icons.delete_forever),
                  //                         Text('Delete User')
                  //                       ],
                  //                     ),
                  //                   )
                  //                 ],
                  //                 onChanged: (value) {
                  //                   log(value.toString());
                  //                   setState(() {
                  //                     dropdownValue = value!;
                  //                   });
                  //                   if (value == 'Record') {
                  //                     getIt.get<Store<AppState>>().dispatch(
                  //                         GetUserEditAction(userEditModel: e));
                  //                     getIt.get<Store<AppState>>().dispatch(
                  //                         GetUserRecordsAction(
                  //                             user_id: e.user_id));
                  //                     openRecordsDialog(
                  //                         option: 'Record', userModelEdit: e);
                  //                   } else if (value == 'Chat') {
                  //                     getIt.get<Store<AppState>>().dispatch(
                  //                         GetUserEditAction(userEditModel: e));
                  //                     getIt.get<Store<AppState>>().dispatch(
                  //                         ChatAction(user_id: e.user_id));
                  //                     openChatDialog(
                  //                         option: 'Chat',
                  //                         userModelEdit: e,
                  //                         adminModel: state.userModel);
                  //                   } else if (value == 'Edit') {
                  //                     getIt.get<Store<AppState>>().dispatch(
                  //                         GetUserEditAction(userEditModel: e));
                  //                     openUserModal(
                  //                         option: 'Edit', userModelEdit: e);
                  //                   } else if (value == 'Delete' &&
                  //                       e.user_id != state.userModel!.user_id) {
                  //                     showDialog<void>(
                  //                       context: context,
                  //                       barrierDismissible: false,
                  //                       // user must tap button!
                  //                       builder: (context) {
                  //                         return AlertDialog(
                  //                           title: Row(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                             children: [Text('Delete')],
                  //                           ),
                  //                           content: SingleChildScrollView(
                  //                             child: ListBody(
                  //                               children: <Widget>[
                  //                                 RedText(
                  //                                     text:
                  //                                     'You are about to delete this account'),
                  //                                 Container(
                  //                                   margin: EdgeInsets.only(
                  //                                       top: 15),
                  //                                   child: DarkRedText(
                  //                                     text:
                  //                                     'Do you want to proceed?',
                  //                                     weight: FontWeight.normal,
                  //                                     size: 14,
                  //                                   ),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           actions: <Widget>[
                  //                             TextButton(
                  //                               child: RedText(
                  //                                 text: 'NO',
                  //                               ),
                  //                               onPressed: () {
                  //                                 Navigator.of(context).pop();
                  //                               },
                  //                             ),
                  //                             TextButton(
                  //                               child: DarkGreenText(
                  //                                 text: 'YES',
                  //                               ),
                  //                               onPressed: () async {
                  //                                 try {
                  //                                   UserCredential userCred =
                  //                                   await FirebaseAuth
                  //                                       .instance
                  //                                       .signInWithEmailAndPassword(
                  //                                       email: e.email,
                  //                                       password:
                  //                                       e.password);
                  //                                   if (userCred.user != null) {
                  //                                     userCred.user!
                  //                                         .delete()
                  //                                         .then((value) {
                  //                                       DocumentReference user =
                  //                                       FirebaseFirestore
                  //                                           .instance
                  //                                           .collection(
                  //                                           'users')
                  //                                           .doc(e.user_id);
                  //                                       user
                  //                                           .delete()
                  //                                           .then((value) {});
                  //                                       Navigator.pop(context);
                  //                                     });
                  //                                   }
                  //                                 } on FirebaseAuthException catch (ex) {
                  //                                   ScaffoldMessenger.of(
                  //                                       context)
                  //                                       .showSnackBar(SnackBar(
                  //                                     // onVisible: () => Timer(
                  //                                     //     Duration(seconds: 2),
                  //                                     //         () => Navigator.of(context).pop()),
                  //                                     backgroundColor:
                  //                                     Colors.green,
                  //                                     content: Container(
                  //                                       // color: Colors.yellow,
                  //                                       child: WhiteText(
                  //                                         text: ex.code,
                  //                                       ),
                  //                                     ),
                  //                                     duration: Duration(
                  //                                         milliseconds: 2000),
                  //                                   ));
                  //                                 }
                  //                               },
                  //                             ),
                  //                           ],
                  //                         );
                  //                       },
                  //                     );
                  //                   } else {
                  //                     ScaffoldMessenger.of(context)
                  //                         .showSnackBar(SnackBar(
                  //                       // onVisible: () => Timer(
                  //                       //     Duration(seconds: 2),
                  //                       //         () => Navigator.of(context).pop()),
                  //                       backgroundColor: Colors.red,
                  //                       content: Container(
                  //                         // color: Colors.yellow,
                  //                         child: WhiteText(
                  //                           text:
                  //                           'Current user cannot be deleted, sign in with different account to delete this user',
                  //                         ),
                  //                       ),
                  //                       duration: Duration(milliseconds: 2000),
                  //                     ));
                  //                   }
                  //                 },
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       Divider(
                  //         height: 1,
                  //         thickness: 1,
                  //         color: DefaultColors().shadowColorGrey,
                  //       )
                  //     ],
                  //   );
                  // }).toList(),
                ],
                      )),
                  Positioned(
                      bottom: 60,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: () {

                        },
                        child: Icon(Icons.add),
                      )),
                ],
              )),
        );
      },
      converter: (Store<AppState> store) => store.state,
    );
  }
}
