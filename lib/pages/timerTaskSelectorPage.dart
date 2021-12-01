
import 'package:flutter/material.dart';
import 'package:king_of_live/model/drop_list_model.dart';
import 'package:king_of_live/model/select_drop_list.dart';


class TaskSelectorPage extends StatefulWidget {
  @override
  _TaskSelectorPageState createState() => _TaskSelectorPageState();
}

class _TaskSelectorPageState extends State<TaskSelectorPage> {

  DropListModel dropListModel = DropListModel([OptionItem(id: "1", title: "Option 1"), OptionItem(id: "2", title: "Option 2")]);
  OptionItem optionItemSelected = OptionItem(id: null, title: "Chọn quyền truy cập");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectDropList(
          this.optionItemSelected,
          this.dropListModel,
              (optionItem){
            optionItemSelected = optionItem;
            setState(() {

            });
          },
        ),
      ],
    ),);
  }
}
