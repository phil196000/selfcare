import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:

          ///Menu Mode with no searchBox
          DropdownSearch<String>(
        validator: (v) => v == null ? "required field" : null,
        // hint: "Select a time",
        mode: Mode.MENU,
        dropdownSearchDecoration: InputDecoration(border: OutlineInputBorder()),
        dropDownButton: Icon(Icons.keyboard_arrow_down),
        dropdownBuilder: (context, selectedItem, itemAsString) {
          return Container(
            child: Row(
              children: [Text(selectedItem ?? 'Select a time')],
            ),
          );
        },
        showSelectedItem: true,
        items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
        // label: "Menu mode *",
        showClearButton: false,
        onChanged: (value) {},
        popupItemDisabled: (String s) => s.startsWith('I'),
        selectedItem: "",
        onBeforeChange: (a, b) {
          // AlertDialog alert = AlertDialog(
          //   title: Text("Are you sure..."),
          //   content: Text("...you want to clear the selection"),
          //   actions: [
          //     FlatButton(
          //       child: Text("OK"),
          //       onPressed: () {
          //         Navigator.of(context).pop(true);
          //       },
          //     ),
          //     FlatButton(
          //       child: Text("NOT OK"),
          //       onPressed: () {
          //         Navigator.of(context).pop(false);
          //       },
          //     ),
          //   ],
          // );

          // return showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return alert;
          //     });
        },
      ),
    );
  }
}
