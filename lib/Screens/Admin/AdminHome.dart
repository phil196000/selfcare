import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:selfcare/CustomisedWidgets/Background.dart';
import 'package:selfcare/CustomisedWidgets/DarkRedText.dart';
import 'package:selfcare/CustomisedWidgets/RedText.dart';
import 'package:selfcare/CustomisedWidgets/WhiteText.dart';
import 'package:selfcare/Data/UserModel.dart';
import 'package:selfcare/Screens/Admin/SummaryStatsCard.dart';
import 'package:selfcare/Theme/DefaultColors.dart';
import 'package:selfcare/main.dart';
import 'package:selfcare/redux/Actions/GetUsersAction.dart';
import 'package:selfcare/redux/AppState.dart';

import 'UserModal.dart';

class AdminHome extends StatefulWidget {
  final Function? hidenavbar;

  AdminHome({this.hidenavbar});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? dropdownValue;

  // UserModel? userModelEdit;

  @override
  void initState() {
    super.initState();
    getIt.get<Store<AppState>>().dispatch(GetUsersAction());
  }

  void openUserModal({String option = 'Add', UserModel? userModelEdit}) {
    widget.hidenavbar!(true);
    // log('pressed');
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => UserFormDialog(
          userModel: userModelEdit,
          option: option,
          closeModal: () {
            widget.hidenavbar!(false);
            Navigator.pop(context);
            setState(() {
              dropdownValue = null;
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

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
                  DarkRedText(
                    text: 'Hello',
                    size: 12,
                  ),
                  DarkRedText(text: 'Admin'),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  RedText(
                    text: 'Summary Stats for all users',
                    size: 14,
                  ),
                  Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      SummaryStatsCard(
                        title: 'Overall',
                        value: state.users!.length.toString(),
                      ),
                      SummaryStatsCard(
                        title: 'Users',
                        value: usersCount.toString(),
                      ),
                      SummaryStatsCard(
                        title: 'Admin',
                        value: adminCount.toString(),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  RedText(
                    text: 'Users',
                  ),
                  ...state.users!.map((e) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(e.full_name),
                          subtitle: Text(e.roles.toString()),
                          // leading: Icon(Icons.label),
                          trailing: DropdownButton<String>(
                            icon: Icon(Icons.more_vert),
                            value: null,

                            // isExpanded: false,

                            underline: Container(
                              height: 0,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                value: 'Edit',
                                child: Row(
                                  children: [Icon(Icons.edit), Text('Edit')],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'View Record',
                                child: Row(
                                  children: [
                                    Icon(Icons.file_copy),
                                    Text('View Record')
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Chat',
                                child: Row(
                                  children: [Icon(Icons.chat), Text('Chat')],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              log(value.toString());
                              setState(() {
                                dropdownValue = value!;
                              });

                              openUserModal(option: 'Edit', userModelEdit: e);
                            },
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: DefaultColors().shadowColorGrey,
                        )
                      ],
                    );
                  }).toList(),

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: DataTable(
                  //     columns: const <DataColumn>[
                  //       DataColumn(
                  //         label: Text(
                  //           'Name',
                  //           style: TextStyle(fontStyle: FontStyle.italic),
                  //         ),
                  //       ),
                  //       DataColumn(
                  //         label: Text(
                  //           'Age',
                  //           style: TextStyle(fontStyle: FontStyle.italic),
                  //         ),
                  //       ),
                  //       DataColumn(
                  //         label: Text(
                  //           'Role',
                  //           style: TextStyle(fontStyle: FontStyle.italic),
                  //         ),
                  //       ),
                  //       DataColumn(
                  //         label: Text(
                  //           'Role',
                  //           style: TextStyle(fontStyle: FontStyle.italic),
                  //         ),
                  //       ),
                  //       DataColumn(
                  //         label: Text(
                  //           'Role',
                  //           style: TextStyle(fontStyle: FontStyle.italic),
                  //         ),
                  //       ),
                  //     ],
                  //     rows: const <DataRow>[
                  //       DataRow(
                  //         cells: <DataCell>[
                  //           DataCell(Text('Sarah')),
                  //           DataCell(Text('19')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Student')),
                  //         ],
                  //       ),
                  //       DataRow(
                  //         cells: <DataCell>[
                  //           DataCell(Text('Janine')),
                  //           DataCell(Text('43')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Professor')),
                  //         ],
                  //       ),
                  //       DataRow(
                  //         cells: <DataCell>[
                  //           DataCell(Text('William')),
                  //           DataCell(Text('27')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //         ],
                  //       ),
                  //       DataRow(
                  //         cells: <DataCell>[
                  //           DataCell(Text('William')),
                  //           DataCell(Text('27')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //           DataCell(Text('Associate Professor')),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              )),
              Positioned(
                  bottom: 60,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      openUserModal();
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
