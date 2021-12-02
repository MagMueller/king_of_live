// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:king_of_live/model/drop_list_model.dart';
import 'package:king_of_live/model/items.dart';
import 'package:king_of_live/model/select_drop_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskSelectorPage extends StatefulWidget {
  @override
  _TaskSelectorPageState createState() => _TaskSelectorPageState();
}

class _TaskSelectorPageState extends State<TaskSelectorPage> {
  late OptionItem optionItemSelected;
  late DropListModel dropListModel;



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectDropList(
            //this.optionItemSelected,
            //this.dropListModel,
            (optionItem) {
              optionItemSelected = optionItem;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }


}
